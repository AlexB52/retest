module Retest
  class Repository
    attr_accessor :files, :cache, :input_stream, :output_stream

    def initialize(files: nil, cache: {}, input_stream: nil, output_stream: nil)
      @cache         = cache
      @files         = files || default_files
      @input_stream  = input_stream || STDIN
      @output_stream = output_stream|| STDOUT
    end

    def find_test(path)
      cache[path] ||= select_test(path)
    end

    private

    def select_test(path)
      tests = files.select { |file| regex(path) =~ file }
        .sort_by { |file| String::Similarity.cosine(path, file) }

      case tests.count
      when 0, 1
        tests.first
      else
        output_question tests.first(3)
        tests[get_input]
      end
    end

    def default_files
      @default_files ||= Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
    end

    def regex(path)
     extname  = File.extname(path)
     basename = File.basename(path, extname)
     Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
    end

    def output_question(tests)
      output_stream.puts "Which file do you want to use?"
      tests.each_with_index do |file, index|
        output_stream.puts "[#{index}] - #{file}"
      end
    end

    def get_input
      input_stream.gets.chomp.to_i
    end
  end
end