def modify_file(path)
  return unless File.exists? path

  old_content = File.read(path)
  File.open(path, 'w') { |file| file.write old_content }

  sleep 0.5
end

class TestLogger < SimpleDelegator
  def initialize
    __setobj__ StringIO.new
  end

  def clear
    truncate(0)
    rewind
  end
end
