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
    expected_options = { relative: true, only: Regexp.new('\\.rb$'), force_polling: false }

    listener.expect(:to, Struct.new(:start).new, ['.'], **expected_options)

    Retest.listen(Options.new, listener: listener)

    listener.verify
  end

  def test_listen_when_polling
    listener = Minitest::Mock.new
    expected_options = { relative: true, only: Regexp.new('\\.rb$'), force_polling: true }

    listener.expect(:to, Struct.new(:start).new, ['.'], **expected_options)

    Retest.listen(Options.new(["--polling"]), listener: listener)

    listener.verify
  end
end
