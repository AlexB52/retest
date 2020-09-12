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
      cache[path] ||= select_from test_options(path)
    end

    private

    def select_from(tests)
      case tests.count
      when 0, 1
        tests.first
      else
        ask_question tests
        tests[get_input]
      end
    end

    def test_options(path)
      return [path] if is_test_file?(path)

      files.select { |file| regex(path) =~ file }
        .sort_by { |file| String::Similarity.levenshtein(path, file) }
        .last(5)
        .reverse
    end

    def default_files
      @default_files ||= Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
    end

    def is_test_file?(path)
       Regexp.new(".*(?:spec|test)#{File.extname(path)}") =~ path
    end

    def regex(path)
     extname  = File.extname(path)
     basename = File.basename(path, extname)
     Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
    end

    def ask_question(tests)
      output_stream.puts <<~QUESTION
        We found few tests matching:
        #{list_options(tests)}

        Which file do you want to use?
        Enter the file number now:
      QUESTION
    end

    def list_options(tests)
      tests.map.with_index do |file, index|
        "[#{index}] - #{file}"
      end.join("\n")
    end

    def get_input
      input_stream.gets.chomp.to_i
    end
  end
end