require "test_helper"

class RetestTest < Minitest::Test
  include Retest

  def test_that_it_has_a_version_number
    refute_nil ::Retest::VERSION
  end
end

class ListenTests < MiniTest::Test
  include Retest

  def test_listen_default_behaviour
    listener = MiniTest::Mock.new
    expected_options = { dir: '.', extensions: ['rb'], polling: false }

    listener.expect(:watch, true, [expected_options])

    Retest.listen(Options.new, listener: listener)

    listener.verify
  end

  def test_listen_when_polling
    listener = MiniTest::Mock.new
    expected_options = { dir: '.', extensions: ['rb'], polling: true }

    listener.expect(:watch, true, [expected_options])

    Retest.listen(Options.new(["--polling"]), listener: listener)

    listener.verify
  end
end
