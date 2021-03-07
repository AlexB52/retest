module Retest
  class VersionControl
    def self.files
      [Git, NoVersionControl].select(&:installed?).first.new.files
    end

    def name; end
    alias :to_s :name

    class NoVersionControl
      def self.installed?
        true
      end

      def name
        'default'
      end

      def files
        Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
      end
    end

    class Git
      def self.installed?
        system "git -C . rev-parse 2>/dev/null"
      end

      def name
        'git'
      end

      def files
        (untracked_files + tracked_files).sort
      end

      private

      def untracked_files
        `git ls-files --other --exclude-standard -z`.split("\x0")
      end

      def tracked_files
        `git ls-files -z`.split("\x0")
      end
    end
  end
end