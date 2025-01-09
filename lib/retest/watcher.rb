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

      def self.watch(dir:, extensions:, polling: false)
        # Process needs its own process group otherwise the process gets killed on INT signal
        # We need the process to still run when trying to stop the current test run
        # Maybe there is another way to prevent killing these but for now a new process groups works
        # Process group created with: Process.setsid
        watch_rd, watch_wr = IO.pipe
        pid = fork do
          Process.setsid
          Listen.to(dir, only: extensions_regex(extensions), relative: true, polling: polling) do |modified, added, removed|
            if modified.any?
              watch_wr.write "modify:#{modified.first}"
            elsif added.any?
              watch_wr.write "create:#{added.first}"
            elsif removed.any?
              watch_wr.write "remove:#{removed.first}"
            end
          end.start
          sleep
        end

        at_exit do
          Process.kill("TERM", pid) if pid
          watch_rd.close
          watch_wr.close
        end

        Thread.new do
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
      end

      def self.extensions_regex(extensions)
        Regexp.new("\\.(?:#{extensions.join("|")})$")
      end
    end

    module Watchexec
      def self.installed?
        system "watchexec --version > /dev/null 2>&1"
      end

      def self.watch(dir:, extensions:, polling: false)
        command = "watchexec --exts #{extensions.join(',')} -w #{dir} --emit-events-to stdio --no-meta --only-emit-events"
        files = VersionControl.files(extensions: extensions).zip([]).to_h

        watch_rd, watch_wr = IO.pipe
        # Process needs its own process group otherwise the process gets killed on INT signal
        # We need the process to still run when trying to stop the current test run
        # Maybe there is another way to prevent killing these but for now a new process groups works
        # Process group created with: pgroup: true
        pid = Process.spawn(command, out: watch_wr, pgroup: true)

        at_exit do
          Process.kill("TERM", pid) if pid
          watch_rd.close
          watch_wr.close
        end

        Thread.new do
          loop do
            ready = IO.select([watch_rd])
            readable_connections = ready[0]
            readable_connections.each do |conn|
              data = conn.readpartial(4096)
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

        # require 'open3'
        # Thread.new do
        #   files = VersionControl.files(extensions: extensions).zip([]).to_h

        #   Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        #     loop do
        #       ready = IO.select([stdout])
        #       readable_connections = ready[0]
        #       readable_connections.each do |conn|
        #         data = conn.readpartial(4096)
        #         change = /^(?:create|remove|rename|modify):(?<path>.*)/.match(data.strip)

        #         next unless change

        #         path = Pathname(change[:path]).relative_path_from(Dir.pwd).to_s
        #         file_exist = File.exist?(path)
        #         file_cached = files.key?(path)

        #         modified, added, removed = result = [[], [], []]
        #         if file_exist && file_cached
        #           modified << path
        #         elsif file_exist && !file_cached
        #           added << path
        #           files[path] = nil
        #         elsif !file_exist && file_cached
        #           removed << path
        #           files.delete(path)
        #         end

        #         yield result
        #       end
        #     end
        #   end
        # end
      end
    end
  end
end