# Can be updated to all feature repositories with
# $ bin/test/reset_helpers

module OutputHelper
  def read_output(output = @output)
    result = ""
    loop do
      result += output.read_nonblock(1024)
    rescue IO::WaitReadable
      break
    end

    if block_given?
      yield result
    else
      result
    end
  end
end

module FileHelper
  def default_sleep_seconds
    Float(ENV.fetch('DEFAULT_SLEEP_SECONDS', 1))
  end

  def launch_sleep_seconds
    Float(ENV.fetch('LAUNCH_SLEEP_SECONDS', 1.5))
  end

  def wait(sleep_seconds: default_sleep_seconds)
    sleep sleep_seconds
  end

  def modify_file(path, sleep_seconds: default_sleep_seconds)
    return unless File.exist? path

    old_content = File.read(path)
    File.open(path, 'w') { |file| file.write old_content }

    sleep sleep_seconds
  end

  def create_file(path, should_sleep: true, sleep_seconds: default_sleep_seconds)
    File.open(path, "w").tap(&:close)

    sleep sleep_seconds if should_sleep
  end

  def delete_file(path)
    return unless File.exist? path

    File.delete path
  end

  def rename_file(path, new_path)
    return unless File.exist? path

    File.rename path, new_path
  end
end

module CommandHelper
  def launch_retest(command, sleep_seconds: Float(ENV.fetch('LAUNCH_SLEEP_SECONDS', 1.5)))
    require 'open3'
    @input, @output, @stderr, @wait_thr = Open3.popen3(command)
    @pid = @wait_thr[:pid]
    sleep sleep_seconds
  end

  def end_retest
    @input&.close
    @stderr&.close
    @output&.close
    if @pid
      Process.kill('SIGHUP', @pid)
      Process.detach(@pid)
    end
  end
end
