require "retest/version"
require "retest/command"
require 'string/similarity'

module Retest
  class Error < StandardError; end

  def find_tests(path, files: [])
    files.select { |file| regex(path) =~ file }
  end

  def find_test(path, files: [])
    find_tests(path, files: files)
      .max_by { |file| String::Similarity.cosine(path, file) }
  end

  private

  def regex(path)
    extname = File.extname(path)
    basename = File.basename(path, extname)
    Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
  end
end
