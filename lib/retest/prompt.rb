module Retest
  class Prompt
    include Observable

    attr_accessor :input, :output
    def initialize(input: nil, output: nil)
      @input  = input || $stdin
      @output = output || $stdout
      @question_asked = false
    end

    def ask_which_test_to_use(path, files)
      changed
      notify_observers(:question)
      options = options(files)

      output.puts(<<~QUESTION)
        We found few tests matching: #{path}

        #{list_options(options.keys)}

        Which file do you want to use?
        Enter the file number now:
      QUESTION
      output.print("> ")
      options.values[input.gets.to_s.chomp.to_i]
    end

    def puts(*args)
      output.puts(*args)
    end

    def read_output
      output.tap(&:rewind).read
    end

    private

    def options(files, blank_option: 'none')
      result = {}
      files.each { |file| result[file] = file }
      result[blank_option] = nil # blank option last
      result
    end

    def list_options(options)
      options
        .map
        .with_index { |file, index| "[#{index}] - #{file}" }
        .join("\n")
    end
  end
end
