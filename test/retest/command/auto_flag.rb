module Retest
  class AutoFlagTest < Minitest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @subject = Command.new(setup: @setup)
    end

    def output
      @out.string
    end

    def test_for_rspec_setup
      @setup.type = :rspec
      assert_equal 'bundle exec rspec <test>', @subject.command.to_s
    end

    def test_for_rails_setup
      @setup.type = :rails
      assert_equal 'bundle exec rails test <test>', @subject.command.to_s
    end

    def test_for_ruby_setup
      @setup.type = :ruby
      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
    end

    def test_for_rake_setup
      @setup.type = :rake
      assert_equal 'bundle exec rake test TEST=<test>', @subject.command.to_s
    end

    def test_for_unknown_setup
      @setup.type = :unknown
      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
    end
  end

  class AutoAllFlagTest < Minitest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @subject = Command.new(
        options: Options.new(['--all']),
        setup: @setup
      )
    end

    def output
      @out.string
    end

    def test_for_rspec_setup
      @setup.type = :rspec
      assert_equal 'bundle exec rspec', @subject.command.to_s
    end

    def test_for_rails_setup
      @setup.type = :rails
      assert_equal 'bundle exec rails test', @subject.command.to_s
    end

    def test_for_ruby_setup
      @setup.type = :ruby
      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
    end

    def test_for_rake_setup
      @setup.type = :rake
      assert_equal 'bundle exec rake test', @subject.command.to_s
    end

    def test_for_unknown_setup
      @setup.type = :unknown
      assert_equal 'bundle exec ruby <test>', @subject.command.to_s
    end
  end
end