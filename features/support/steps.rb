Given('I cd in a ruby project with tests') do
  `cp -r features/fixture_project tmp/aruba`
   steps %Q{And I cd to "fixture_project"}
end

Given('I run retest with {string}') do |command|
  @file = OutputFile.new
  @pid = Process.spawn command, out: @file.path
  sleep 1
end

Given('I modify file {string}') do |pathname|
  modify_file pathname
end

Then('the logger should output:') do |doc_string|
  assert_match doc_string, @file.read
end

Then('the logger should not output:') do |doc_string|
  refute_match doc_string, @file.read
end

Then('the logger should output the help') do
  assert_match File.read('test/retest/options/help.txt'), @file.read
end
