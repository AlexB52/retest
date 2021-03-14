require 'securerandom'

class OutputFile
  attr_reader :id

  def initialize
    @id = SecureRandom.hex(10)
    create_file
  end

  def path
    "tmp/output-#{id}.log"
  end
  alias :to_s :path

  def read
    return unless File.exists?(path)

    File.read(path).split('[H[J').last
  end

  def delete
    return unless File.exists?(path)

    File.delete(path)
  end
  alias :clear :delete

  private

  def create_file
    Dir.mkdir('tmp') unless Dir.exists?('tmp')
    File.open(path, "w")
  end
end
