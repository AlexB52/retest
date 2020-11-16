module Configurable
  def self.included(base)
    base.extend ClassMethods
  end

  class Configuration
    extend Forwardable

    attr_accessor :logger

    def_delegator :logger, :puts
    alias :log :puts
  end

  module ClassMethods
    extend Forwardable

    attr_writer :configuration

    def_delegators :configuration, :log, :logger, :logger=

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end