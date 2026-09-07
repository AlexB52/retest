module Retest
  class Repository
    attr_accessor :files, :cache, :prompt

    def initialize(files: [], cache: {}, prompt: nil)
      @cache  = cache
      @files  = files
      @prompt = prompt || Prompt.new
    end

    def find_test(path)
      return unless path
      return if path.empty?

      matching_path = path_without_line_number(path)

      unless cache.key?(matching_path)
        ok_to_cache, test_file = select_from matching_path, MatchingOptions.for(matching_path, files: files)
        if ok_to_cache
          cache[matching_path] = test_file
        end
      end

      with_line_number(path, cache[matching_path])
    end

    def find_tests(paths)
      search_tests(paths)
        .values
        .compact
        .uniq
        .sort
    end

    def search_tests(paths)
      result = {}
      ruby_files = paths.select { |path| ruby_file?(path) }

      ruby_files.each do |path|
        result[path] ||= find_test(path)
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

    def ruby_file?(path)
      path_without_line_number(path).end_with?('.rb')
    end

    def path_without_line_number(path)
      path.to_s.sub(/:\d+\z/, '')
    end

    def line_number(path)
      path.to_s[/:(\d+)\z/, 1]
    end

    def with_line_number(path, test_file)
      return test_file unless test_file
      number = line_number(path)

      return test_file unless number
      return test_file unless MatchingOptions::Path.new(path_without_line_number(path)).test?

      "#{test_file}:#{number}"
    end

    def select_from(path, matching_tests)
      case matching_tests.count
      when 0
        [false, nil]
      when  1
        [true, matching_tests.first]
      else
        [true, prompt.ask_which_test_to_use(path, matching_tests)]
      end
    end
  end
end
