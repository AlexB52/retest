require_relative 'matching_options/path'

module Retest
  class MatchingOptions
    def self.for(path, files: [], limit: nil)
      new(path, files: files, limit: limit).filtered_results
    end

    attr_reader :path, :files, :test_directories

    def initialize(path, files: [], limit: 5, test_directories: nil)
      @path = Path.new(path)
      @files = files
      @limit = limit || 5
      @test_directories = (test_directories || %w[spec test]) + %w[.] # add root file as a valid test directory
    end

    def filtered_results
      if path.test?(test_directories: test_directories)
        # If input is a test file, find exact or partial matches
        exact_match = files.find { |file| file == path.to_s }
        if exact_match
          [Path.new(exact_match)]
        else
          # Find files that end with this test file name
          partial_matches = files.select { |file| file.end_with?(path.to_s) }
          partial_matches.empty? ? [] : partial_matches.map { |file| Path.new(file) }
        end
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
      test_files = files
        .map { |file| Path.new(file) }
        .select { |path| (path.reversed_dirnames & test_directories).any? }

      path
        .reversed_dirnames
        .each
        .with_index
        .with_object(test_files) do |(dirname, index), tests|
          break tests if tests.count <= 1

          tests.keep_if { |test| test.reversed_dirnames[index] == dirname }
        end
    end
  end
end