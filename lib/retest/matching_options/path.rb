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

      def ==(other)
        pathname == other.pathname
      end

      def reversed_dirnames
        @reversed_dirnames ||= dirnames.reverse
      end

      def dirnames
        @dirnames ||= dirname.each_filename.to_a
      end

      def test?(test_directories: nil)
        if test_directories && (test_directories & dirnames).empty?
          return false
        end

        test_regexs.any? { |regex| regex =~ to_s }
      end

      def possible_test?(file, test_directories: nil)
        if test?(test_directories: test_directories)
          other = Path.new(file)
          self == other || test_subset?(other)
        else
          possible_test_regexs.any? { |regex| regex =~ file }
        end
      end

      def similarity_score(file)
        String::Similarity.levenshtein(to_s, file)
      end

      def filename
        basename(extname)
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

      # This method checks whether the test file is included in the path of
      # another test file
      # Example: fixture_test.rb is included in test/valuation/fixture_test.rb
      def test_subset?(other)
        if dirnames == ['.']
          filename == other.filename
        else
          filename == other.filename && Set.new(dirnames).subset?(Set.new(other.dirnames))
        end
      end
    end
  end
end
