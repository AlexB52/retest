module Interruptions
  # Don't forget to end_retest in the class
  # def teardown
  #   end_retest
  # end

  def test_interrupting_a_run
    launch_retest @command

    create_file('spec/long_running_spec.rb', content: <<~CONTENT)
      require 'spec_helper'
      RSpec.describe 'A long running spec' do
        10.times do |i|
          it { expect(true).to eq true }
        end

        it 'takes forever' do
          sleep
        end
      end
    CONTENT

    assert_output_matches("Test file: spec/long_running_spec.rb")

    sleep 2

    Process.kill('INT', @pid)

    assert_output_matches(
      /Finished in .* seconds \(files took .* seconds to load\)/,
      /\d+ examples, 0 failures/,
      "Type interactive command and press enter. Enter 'h' for help."
    )
  ensure
    File.delete("spec/long_running_spec.rb")
  end
end
