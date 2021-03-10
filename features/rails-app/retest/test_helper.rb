require_relative 'support/output_file'

module FileHelper
  def modify_file(path)
    return unless File.exists? path

    old_content = File.read(path)
    File.open(path, 'w') { |file| file.write old_content }

    sleep 10
  end

  def create_file(path, should_sleep: true)
    File.open(path, "w").tap(&:close)

    sleep 10 if should_sleep
  end

  def delete_file(path)
    return unless File.exists? path

    File.delete path
  end
end

def launch_retest(command)
  file = OutputFile.new
  pid  = Process.spawn command, out: file.path
  sleep 1.5
  [file, pid]
end

def end_retest(file, pid)
  file&.delete
  if pid
    Process.kill('SIGHUP', pid)
    Process.detach(pid)
  end
end