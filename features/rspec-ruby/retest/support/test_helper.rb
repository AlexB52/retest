# Can be updated to all feature repositories with
# $ bin/test/reset_helpers

module RetestHelper
  # COMMAND
  def launch_retest(command, sleep_for: Float(ENV.fetch('LAUNCH_SLEEP_SECONDS', 1.5)))
    require 'open3'
    @input, @output, @stderr, @wait_thr = Open3.popen3(command)
    @pid = @wait_thr[:pid]
    sleep sleep_for
  end

  def end_retest
    @input&.close
    @stderr&.close
    @output&.close
    @wait_thr&.exit
  end

  # ASSERTIONS
  def assert_output_matches(*expectations, max_retries: 5)
    retries = 0
    wait_for = 0.1
    output = ""
    begin
      output += read_output
      expectations.each { |expectation| assert_match(expectation, output) }
    rescue Minitest::Assertion => e
      raise e if retries >= max_retries
      retries += 1
      sleep_seconds = wait_for ** -(wait_for * retries)
      sleep sleep_seconds
      retry
    end
  end

  # OUTPUT
  def read_output(output = @output)
    result = ""
    loop do
      result += output.read_nonblock(1024)
    rescue IO::WaitReadable, EOFError
      break
    end

    if block_given?
      yield result
    else
      result
    end
  end

  # INPUT
  def write_input(command, input: @input, sleep_for: 0.1)
    input.write(command)
    wait(sleep_for)
  end

  # FILE CHANGES
  def modify_file(path, sleep_for: default_sleep_seconds)
    return unless File.exist? path

    old_content = File.read(path)
    File.open(path, 'w') { |file| file.write old_content }
    wait(sleep_for)
  end

  def create_file(path, content: "", sleep_for: default_sleep_seconds)
    File.open(path, "w") { |f| f.write(content) }
    wait(sleep_for)
  end

  def delete_file(path, sleep_for: 0)
    return unless File.exist? path

    File.delete path
    wait(sleep_for)
  end

  def rename_file(path, new_path, sleep_for: 0)
    return unless File.exist? path

    File.rename path, new_path
    wait(sleep_for)
  end

  def default_sleep_seconds
    Float(ENV.fetch('DEFAULT_SLEEP_SECONDS', 1))
  end

  def launch_sleep_seconds
    Float(ENV.fetch('LAUNCH_SLEEP_SECONDS', 1.5))
  end

  def wait(sleep_for = default_sleep_seconds)
    sleep sleep_for
  end
end
