require 'forwardable'

module Retest
  module TestOptions
    class << self
      def for(path, files: [])
        path = Path.new(path)
        return [path.to_s] if path.test?

        possible_tests    = filter_by_string_similarities(path, files)
        namespace_screens = filter_by_namespaces(path, possible_tests.dup)

        (namespace_screens.any? ? namespace_screens : possible_tests).map(&:to_s)
      end

      def filter_by_string_similarities(path, files)
        files
          .select      { |file| regex(path) =~ file }
          .sort_by     { |file| [String::Similarity.levenshtein(path.to_s, file), file] }
          .last(5).map { |file| Path.new(file) }
          .reverse
      end

      def filter_by_namespaces(path, possible_test_paths)
        path
          .reversed_dirnames
          .each_with_index
          .with_object(possible_test_paths) do |(reference, index), result|
            unless [1, 0].include? result.count
              result.keep_if { |path| path.reversed_dirnames[index] == reference }
            end
          end
      end

      def regex(path)
        Regexp.new(".*#{path.basename(path.extname)}_(?:spec|test)#{path.extname}")
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
        Regexp.new(".*(?:spec|test)#{extname}") =~ to_s
      end
    end
  end
end
