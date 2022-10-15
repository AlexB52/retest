require_relative 'matching_options/path'

module Retest
  class MatchingOptions
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
      elsif (screened_tests = screen_namespaces(possible_tests)).any?
        screened_tests
      else
        possible_tests
      end.map(&:to_s)
    end

    private

    def possible_tests
      @possible_tests ||= files
        .select  { |file| path.possible_test?(file) }
        .sort_by { |file| [-path.similarity_score(file), file] }
        .first(@limit)
    end

    def screen_namespaces(files)
      path
        .reversed_dirnames
        .each
        .with_index
        .with_object(files.map { |file| Path.new(file) }) do |(dirname, index), paths|
          break paths if paths.count <= 1

          paths.keep_if { |path| path.reversed_dirnames[index] == dirname }
        end
    end
  end
end