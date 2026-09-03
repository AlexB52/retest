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

      def files(extensions: [])
        result = (untracked_files + tracked_files).sort
        unless extensions.empty?
          result.select! { |file| /\.(?:#{extensions.join('|')})$/.match?(file) }
        end
        result
      end

      def diff_files(branch)
        branch_diff_files   = git_diff_files("#{branch}...HEAD")
        staged_diff_files   = git_diff_files("--staged")
        unstaged_diff_files = git_diff_files

        (
          branch_diff_files +
          staged_diff_files +
          unstaged_diff_files +
          untracked_files
        ).uniq
      end

      def untracked_files
        `git ls-files --other --exclude-standard -z`.split("\x0")
      end

      def tracked_files
        `git ls-files -z`.split("\x0")
      end

      def git_diff_files(*args)
        IO.popen(['git', 'diff', *args, '--name-only', '--diff-filter=ACMRT', '-z'], &:read).split("\x0")
      end
    end
  end
end
