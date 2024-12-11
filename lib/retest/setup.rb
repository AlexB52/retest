module Retest
  class Setup
    def type
      @type ||= begin
        return :ruby unless has_lock_file?

        if    rspec? then :rspec
        elsif rails? then :rails
        elsif rake?  then :rake
        else              :ruby
        end
      end
    end

    private

    def has_lock_file?
      File.exist? 'Gemfile.lock'
    end

    def rspec?
      has_gem? 'rspec'
    end

    def rails?
      has_gem? 'rails'
    end

    def rake?
      has_gem? 'rake'
    end

    def has_gem?(gem_name)
      !`cat Gemfile.lock | grep #{gem_name}`.empty?
    end
  end
end