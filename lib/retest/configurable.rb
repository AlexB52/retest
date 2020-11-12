module Configurable
  def self.included(base)
    base.extend ClassMethods
  end

  class Configuration
    attr_accessor :logger
  end

  module ClassMethods
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def logger
      configuration.logger
    end

    def logger=(logger)
      configuration.logger = logger
    end
  end
end