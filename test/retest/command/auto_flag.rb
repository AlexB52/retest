module Retest
  class AutoFlagTest < MiniTest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @out = StringIO.new

      @subject = Command.new(setup: @setup, stdout: @out)
    end

    def output
      @out.string
    end

    def test_for_rspec_setup
      @setup.type = :rspec

      assert_equal 'bundle exec rspec <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RSPEC]
        Command: 'bundle exec rspec <test>'
      OUTPUT
    end

    def test_for_rails_setup
      @setup.type = :rails

      assert_equal 'bundle exec rails test <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RAILS]
        Command: 'bundle exec rails test <test>'
      OUTPUT
    end

    def test_for_ruby_setup
      @setup.type = :ruby

      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RUBY]
        Command: 'bundle exec ruby <test>'
      OUTPUT
    end

    def test_for_rake_setup
      @setup.type = :rake

      assert_equal 'bundle exec rake test TEST=<test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RAKE]
        Command: 'bundle exec rake test TEST=<test>'
      OUTPUT
    end

    def test_for_unknown_setup
      @setup.type = :unknown

      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [UNKNOWN]
        Command: 'bundle exec ruby <test>'
      OUTPUT
    end
  end

  class AutoAllFlagTest < MiniTest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @out = StringIO.new

      @subject = Command.new(
        options: Options.new(['--all']),
        setup: @setup,
        stdout: @out)
    end

    def output
      @out.string
    end

    def test_for_rspec_setup
      @setup.type = :rspec

      assert_equal 'bundle exec rspec', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RSPEC]
        Command: 'bundle exec rspec'
      OUTPUT
    end

    def test_for_rails_setup
      @setup.type = :rails

      assert_equal 'bundle exec rails test', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RAILS]
        Command: 'bundle exec rails test'
      OUTPUT
    end

    def test_for_ruby_setup
      @setup.type = :ruby

      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RUBY]
        Command: 'bundle exec ruby <test>'
      OUTPUT
    end

    def test_for_rake_setup
      @setup.type = :rake

      assert_equal 'bundle exec rake test', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [RAKE]
        Command: 'bundle exec rake test'
      OUTPUT
    end

    def test_for_unknown_setup
      @setup.type = :unknown

      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
      assert_equal(<<~OUTPUT, output)
        Setup: [UNKNOWN]
        Command: 'bundle exec ruby <test>'
      OUTPUT
    end
  end
end