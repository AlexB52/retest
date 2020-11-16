module Retest
  class Repository
    attr_accessor :files, :cache, :input_stream

    def initialize(files: nil, cache: {}, input_stream: nil)
      @cache         = cache
      @files         = files || default_files
      @input_stream  = input_stream || STDIN
    end

    def find_test(path)
      cache[path] ||= select_from TestOptions.for(path, files: files)
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

    def default_files
      @default_files ||= Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
    end

    def ask_question(tests)
      Retest.log <<~QUESTION
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