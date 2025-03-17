require "test_helper"

class RetestTest < Minitest::Test
  include Retest

  def test_that_it_has_a_version_number
    refute_nil ::Retest::VERSION
  end
end

class ListenTests < Minitest::Test
  include Retest

  def test_listen_default_behaviour
    listener = Minitest::Mock.new
    expected_options = { dir: '.', extensions: ['rb'], polling: false }

    if Gem::Version.new(Minitest::VERSION) > Gem::Version.new("5.15")
      listener.expect(:watch, true, **expected_options)
    else
      listener.expect(:watch, true, [expected_options])
    end

    Retest.listen(Options.new, listener: listener)

    listener.verify
  end

  def test_listen_when_polling
    listener = Minitest::Mock.new
    expected_options = { dir: '.', extensions: ['rb'], polling: true }

    if Gem::Version.new(Minitest::VERSION) > Gem::Version.new("5.15")
      listener.expect(:watch, true, **expected_options)
    else
      listener.expect(:watch, true, [expected_options])
    end

    Retest.listen(Options.new(["--polling"]), listener: listener)

    listener.verify
  end
end
