module Retest
  module VersionControl
    module Git

      module_function

      def installed?
        system "git -C . rev-parse 2>/dev/null"
      end

      def name
        'git'
      end

      def files
        (untracked_files + tracked_files).sort
      end

      def diff_files(branch)
        `git diff #{branch} --name-only --diff-filter=ACMRT -z`.split("\x0")
      end

      def untracked_files
        `git ls-files --other --exclude-standard -z`.split("\x0")
      end

      def tracked_files
        `git ls-files -z`.split("\x0")
      end
    end
  end
end
