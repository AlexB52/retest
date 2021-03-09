def modify_file(path)
  puts "Modifying file..."
  return unless File.exists? path

  old_content = File.read(path)
  File.open(path, 'w') { |file| file.write old_content }

  sleep 1.5
  puts "File modified"
end

$stdout.sync = true

modify_file('test/bottles_test.rb')
modify_file('test/bottles_test.rb')
sleep 5

puts File.read('output.log').gsub '[H[J', ''
File.delete('output.log')
