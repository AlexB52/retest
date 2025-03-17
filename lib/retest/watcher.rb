require 'pathname'

module Retest
  module Watcher
    def self.for(watcher)
      tool = case watcher.to_s
        when 'listen'        then Default
        when 'watchexec'     then Watchexec
        when '', 'installed' then installed
        else                 raise ArgumentError, "Unknown #{watcher}"
        end

      unless tool.installed?
        raise ArgumentError, "#{watcher} not installed on machine"
      end

      tool
    end

    def self.installed
      [Watchexec, Default].find(&:installed?)
    end

    module Default
      def self.installed?
        true
      end

      def self.extensions_regex(extensions)
        Regexp.new("\\.(?:#{extensions.join("|")})$")
      end

      def self.watch(dir:, extensions:, polling: false)
        executable = File.expand_path("../../scripts/listen", __FILE__)
        command = "#{executable} --exts #{extensions.join(',')} -w #{dir} --polling #{polling}"

        watch_rd, watch_wr = IO.pipe
        # Process needs its own process group otherwise the process gets killed on INT signal
        # We need the process to still run when trying to stop the current test run
        # Maybe there is another way to prevent killing these but for now a new process groups works
        # Process group created with: pgroup: true
        pid = Process.spawn(command, out: watch_wr, pgroup: true)

        thread = Thread.new do
          loop do
            ready = IO.select([watch_rd])
            readable_connections = ready[0]
            readable_connections.each do |conn|
              data = conn.readpartial(4096)
              change = /^(?<action>create|remove|modify):(?<path>.*)/.match(data.strip)

              next unless change

              modified, added, removed = result = [[], [], []]
              case change[:action]
              when 'modify' then modified << change[:path]
              when 'create' then added << change[:path]
              when 'remove' then removed << change[:path]
              end

              yield result
            end
          end
        end

        at_exit do
          thread.exit
          Process.kill("TERM", pid) if pid
          watch_rd.close
          watch_wr.close
        end
      end
    end

    module Watchexec
      def self.installed?
        system "watchexec --version > /dev/null 2>&1"
      end

      def self.watch(dir:, extensions:, polling: false)
        command = "watchexec --exts #{extensions.join(',')} -w #{dir} --emit-events-to stdio --no-meta --only-emit-events"

        watch_rd, watch_wr = IO.pipe
        # Process needs its own process group otherwise the process gets killed on INT signal
        # We need the process to still run when trying to stop the current test run
        # Maybe there is another way to prevent killing these but for now a new process groups works
        # Process group created with: pgroup: true
        pid = Process.spawn(command, out: watch_wr, pgroup: true)

        thread = Thread.new do
          files = VersionControl.files(extensions: extensions).zip([]).to_h

          loop do
            ready = IO.select([watch_rd])
            readable_connections = ready[0]
            readable_connections.each do |conn|
              data = conn.readpartial(4096)
              # Watchexec is not great at figuring out whether a file has been deleted and comes as an update.
              # This is why we're not looking at the action like we do with Listen.
              change = /^(?:create|remove|rename|modify):(?<path>.*)/.match(data.strip)

              next unless change

              path = Pathname(change[:path]).relative_path_from(Dir.pwd).to_s
              file_exist = File.exist?(path)
              file_cached = files.key?(path)

              modified, added, removed = result = [[], [], []]
              if file_exist && file_cached
                modified << path
              elsif file_exist && !file_cached
                added << path
                files[path] = nil
              elsif !file_exist && file_cached
                removed << path
                files.delete(path)
              end

              yield result
            end
          end
        end

        at_exit do
          thread.exit
          Process.kill("TERM", pid) if pid
          watch_rd.close
          watch_wr.close
        end
      end
    end
  end
end