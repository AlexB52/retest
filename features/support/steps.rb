Given('I cd in a ruby project with tests') do
  `cp -r features/fixture_project tmp/aruba`
   steps %Q{And I cd to "fixture_project"}
end

When('I run retest with {string}') do |command|
  command  = Retest::Command.for(command)
  @listener = Retest.build(command: command, clear_window: false)
  @listener.start
  sleep 0.4
end

Given('I modify file {string}') do |pathname|
  modify_file pathname
end

Then('the logger should output:') do |doc_string|
  assert_equal doc_string, Retest.logger.string
end
