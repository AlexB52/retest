class OutputFile
  def initialize
    create_file
  end

  def path
    "output.log"
  end
  alias :to_s :path

  def read
    return unless File.exists?(path)

    File.read(path)
  end

  def delete
    return unless File.exists?(path)

    File.delete(path)
  end
  alias :clear :delete

  private

  def create_file
    File.open(path, "w")
  end
end

$stdout.sync = true
puts "starting test"
@file = OutputFile.new
@pid = Process.spawn "retest --rake", out: @file.path
puts "retest started in a thread"
sleep