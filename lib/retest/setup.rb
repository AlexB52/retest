module Retest
  class Setup
    def self.type
      new.type
    end

    def type
      @type ||= begin
        return :ruby unless has_lock_file?

        if rspec?
          :rspec
        elsif rails?
          :rails
        elsif rake?
          :rake
        else
          :ruby
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