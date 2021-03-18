module Retest
  class Repository
    attr_accessor :files, :cache, :input_stream, :output_stream

    def initialize(files: [], cache: {}, input_stream: nil, output_stream: nil)
      @cache         = cache
      @files         = files
      @input_stream  = input_stream || STDIN
      @output_stream = output_stream|| STDOUT
    end

    def find_test(path)
      return unless path
      return if path.empty?

      @path = path
      cache[@path] ||= select_from TestOptions.for(@path, files: files)
    end

    def add(added)
      return if added&.empty?

      files.push(*added)
      files.sort!
    end

    def remove(removed)
      return if removed&.empty?

      if removed.is_a?(Array)
        removed.each { |file| files.delete(file) }
      else
        files.delete(removed)
      end
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

    def ask_question(tests)
      output_stream.puts <<~QUESTION
        We found few tests matching: #{@path}
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