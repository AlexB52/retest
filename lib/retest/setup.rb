module Retest
  class Setup
    def self.type
      new.type
    end

    def type
      @type ||= begin
        return :ruby unless has_gemfile?

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

    def has_gemfile?
      File.exist? 'Gemfile'
    end

    def rspec?
      has_gem? 'rspec'
    end

    def rails?
      File.exist? 'bin/rails'
    end

    def rake?
      has_gem? 'rake'
    end

    def has_gem?(gem_name)
      !`cat Gemfile | grep #{gem_name}`.empty?
    end
  end
end