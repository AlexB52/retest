module Retest
  class Repository
    attr_accessor :files

    def initialize(files: nil)
      @files = files || default_files
    end

    def find_test(path)
     find_tests(path)
       .max_by { |file| String::Similarity.cosine(path, file) }
    end

    def find_tests(path)
      files.select { |file| regex(path) =~ file }
    end

    private

    def default_files
      @default_files ||= Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
    end

    def regex(path)
     extname  = File.extname(path)
     basename = File.basename(path, extname)
     Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
    end
  end
end