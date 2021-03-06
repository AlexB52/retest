def modify_file(path)
  puts "Modifying file..."
  return unless File.exist? path

  old_content = File.read(path)
  File.open(path, 'w') { |file| file.write old_content }

  sleep 1.5
  puts "File modified"
end

$stdout.sync = true

modify_file('lib/bookshelf/entities/book.rb')
modify_file('lib/bookshelf/entities/book.rb')
sleep 5

puts File.read('output.log').gsub '[H[J', ''
File.delete('output.log')
