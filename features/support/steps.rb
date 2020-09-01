require 'byebug'

Given('I cd in a ruby project with tests') do
  `cp -r features/fixture_project tmp/aruba`
   steps %Q{And I cd to "fixture_project"}
end
