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

      @path = path
      cache[@path] ||= select_from MatchingOptions.for(@path, files: files)
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

    def select_from(tests)
      case tests.count
      when 0, 1
        tests.first
      else
        prompt.ask_which_test_to_use(@path, tests)
      end
    end
  end
end