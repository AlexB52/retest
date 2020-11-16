def modify_file(path)
  return unless File.exists? path
  content = File.read(path)

  File.open path, 'w' do |f|
    f.write content
    sleep 0.4
  end
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
