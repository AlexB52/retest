class OutputFile
  attr_reader :output
  def initialize
    @output = Tempfile.new
  end

  def path
    @output.path
  end

  def read
    @output.rewind
    @output.read.split('[H[J').last
  end

  def delete
    @output.close
    @output.unlink
  end
  alias :clear :delete
end
