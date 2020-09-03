module Retest
  class Command
    def self.for(test_command)
      command_class = if test_command.include? '<test>'
        VariableCommand
      else
        HardcodedCommand
      end

      command_class.new test_command
    end

    class VariableCommand
      attr_reader :command, :files, :cache

      def initialize(command, files: nil, cache: {})
        @command = command
        @cache = cache
        @files = files || default_files
      end

      def ==(obj)
        command == obj.command
      end

      def run(file_changed)
        if find_test(file_changed)
          system command.gsub('<test>', find_test(file_changed))
        else
          puts 'Could not find a file test matching'
        end
      end

      private

      def find_test(path)
        cache[path] ||= files
          .select { |file| regex(path) =~ file }
          .max_by { |file| String::Similarity.cosine(path, file) }
      end

      def regex(path)
        extname = File.extname(path)
        basename = File.basename(path, extname)
        Regexp.new(".*#{basename}_(?:spec|test)#{extname}")
      end

      def default_files
        @default_files ||= Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
      end
    end

    HardcodedCommand = Struct.new(:command) do
      def run(file_changed)
        system command
      end
    end
  end
end