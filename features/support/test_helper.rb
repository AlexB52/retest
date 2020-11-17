def clear_output
  File.open("tmp/output.log", 'w') { |f| f.write ""}
end

def read_output
  File.read("tmp/output.log")
end

def modify_file(path)
  return unless File.exists? path

  old_content = File.read(path)
  File.open(path, 'w') { |file| file.write old_content }

  sleep 0.75
end