module Retest
  module TestOptions
    def self.for(path, files: [])
      return [path] if is_test_file?(path)

      files.select { |file| regex(path) =~ file }
        .sort_by   { |file| String::Similarity.levenshtein(path, file) }
        .last(5)
        .reverse
    end

    def self.is_test_file?(path)
       Regexp.new(".*(?:spec|test)#{File.extname(path)}") =~ path
    end

    def self.regex(path)
      extname  = File.extname(path)
      basename = File.basename(path, extname)
      Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
    end
  end
end