require 'forwardable'

module Retest
  class MatchingOptions
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
