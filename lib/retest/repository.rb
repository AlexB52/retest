module Retest
  class Repository
    attr_accessor :files, :cache, :stdin, :stdout

    def initialize(files: [], cache: {}, stdin: $stdin, stdout: $stdout)
      @cache  = cache
      @files  = files
      @stdin  = stdin
      @stdout = stdout
    end

    def find_test(path)
      return unless path
      return if path.empty?

      @path = path
      cache[@path] ||= select_from TestOptions.for(@path, files: files)
    end

    def find_tests(paths)
      paths
        .select { |path| Regexp.new("\.rb$") =~ path }
        .map    { |path| find_test(path) }
        .compact
        .uniq
        .sort
    end

    def sync(added:, removed:)
      add(added)
      remove(removed)
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
        ask_which_test_to_use(tests)
      end
    end

    def ask_which_test_to_use(tests)
      stdout.puts(<<~QUESTION)
        We found few tests matching: #{@path}
        #{list_options(tests)}

        Which file do you want to use?
        Enter the file number now:
      QUESTION

      tests[stdin.gets.chomp.to_i]
    end

    def list_options(tests)
      tests.map.with_index do |file, index|
        "[#{index}] - #{file}"
      end.join("\n")
    end
  end
end