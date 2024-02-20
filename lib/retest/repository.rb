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

      unless cache.key?(path)
        ok_to_cache, test_file = select_from path, MatchingOptions.for(path, files: files)
        if ok_to_cache
          cache[path] = test_file
        end
      end

      cache[path]
    end

    def find_tests(paths)
      paths
        .select { |path| Regexp.new("\.rb$") =~ path }
        .map    { |path| find_test(path) }
        .compact
        .uniq
        .sort
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