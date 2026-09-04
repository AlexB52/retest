module Retest
  class Repository
    attr_accessor :files, :cache, :prompt

    def initialize(files: [], cache: {}, prompt: nil)
      @cache  = cache
      @files  = files
      @prompt = prompt || Prompt.new
    end

    def find_test(path, pick: :prompt)
      return unless path
      return if path.empty?

      pick = normalize_pick(pick)

      if pick == :prompt && cache.key?(path)
        return cache[path]
      end

      ok_to_cache, test_file = select_from path, MatchingOptions.for(path, files: files), pick: pick
      cache[path] = test_file if ok_to_cache
      test_file
    end

    def find_tests(paths, pick: :prompt)
      search_tests(paths, pick: pick)
        .values
        .compact
        .uniq
        .sort
    end

    def search_tests(paths, pick: :prompt)
      result = {}
      ruby_files = paths.select { |path| path.end_with?('.rb') }

      ruby_files.each do |path|
        result[path] ||= find_test(path, pick: pick)
      end

      result
    end


    def test_files
      files.select { |file| MatchingOptions::Path.new(file).test? }
    end

    def sync(added:, removed:)
      add(added)
      remove(removed)
    end

    def add(added)
      return if added&.empty?

      files.push(*added)
      files.sort!
    end

    def remove(removed)
      return if removed&.empty?

      if removed.is_a?(Array)
        removed.each { |file| files.delete(file) }
      else
        files.delete(removed)
      end
    end

    private

    def normalize_pick(pick)
      pick = pick.to_sym
      return pick if %i[prompt none one].include?(pick)

      raise ArgumentError, "unknown pick strategy: #{pick}"
    end

    def select_from(path, matching_tests, pick: :prompt)
      case matching_tests.count
      when 0
        [false, nil]
      when  1
        [true, matching_tests.first]
      else
        case pick
        when :prompt
          [true, prompt.ask_which_test_to_use(path, matching_tests)]
        when :none
          [false, nil]
        when :one
          [false, matching_tests.first]
        else
          raise ArgumentError, "unknown pick strategy: #{pick}"
        end
      end
    end
  end
end
