Given('I cd in a ruby project with tests') do
  `cp -r features/fixture_project tmp/aruba`
   steps %Q{And I cd to "fixture_project"}
end

Given('I run retest with {string}') do |command|
  @pid = Process.spawn command, out: "tmp/output.log"
  sleep 0.75
end

Given('I modify file {string}') do |pathname|
  modify_file pathname
end

Then('the logger should output:') do |doc_string|
  assert_match doc_string, read_output
end
