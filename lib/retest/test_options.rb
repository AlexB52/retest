require 'forwardable'

module Retest
  class TestOptions
    def self.for(path, files: [], limit: nil)
      new(path, files: files, limit: limit).filtered_results
    end

    attr_reader :path, :files

    def initialize(path, files: [], limit: 5)
      @path = Path.new(path)
      @files = files
      @limit = limit || 5
    end

    def filtered_results
      if path.test?
        [path]
      elsif namespace_screens.any?
        namespace_screens
      else
        possible_tests
      end.map(&:to_s)
    end

    private

    def possible_tests
      @possible_tests ||= filter_by_string_similarities(path, files)
        .last(@limit)
        .reverse
    end

    def filter_by_string_similarities(path, files)
      files.select  { |file| path.possible_test?(file) }
           .sort_by { |file| [path.similarity_score(file), file] }
    end

    def namespace_screens
      @namespace_screens ||= path
        .reversed_dirnames
        .each_with_index
        .with_object(possible_tests.map { |file| Path.new(file) }) do |(reference, index), result|
          unless [1, 0].include? result.count
            result.keep_if { |path| path.reversed_dirnames[index] == reference }
          end
        end
    end

    class Path
      extend Forwardable

      def_delegators :pathname, :to_s, :basename, :extname, :dirname

      attr_reader :pathname
      def initialize(path)
        @pathname = Pathname(path)
      end

      def reversed_dirnames
        @reversed_dirnames ||= dirname.each_filename.to_a.reverse
      end

      def test?
        test_regexs.any? { |regex| regex =~ to_s }
      end

      def possible_test?(file)
        possible_test_regexs.any? { |regex| regex =~ file }
      end

      def similarity_score(file)
        String::Similarity.levenshtein(to_s, file)
      end

      private

      def test_regexs
        [
          Regexp.new("^(.*\/)?.*_(?:spec|test)#{extname}$"),
          Regexp.new("^(.*\/)?(?:spec|test)_.*#{extname}$"),
        ]
      end

      def possible_test_regexs
        [
          Regexp.new("^(.*\/)?.*#{filename}_(?:spec|test)#{extname}$"),
          Regexp.new("^(.*\/)?.*(?:spec|test)_#{filename}#{extname}$"),
        ]
      end

      def filename
        basename(extname)
      end
    end
  end
end