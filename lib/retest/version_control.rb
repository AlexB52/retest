require_relative 'version_control/git'
require_relative 'version_control/no_version_control'

module Retest
  class VersionControl
    def self.files
      [Git, NoVersionControl].select(&:installed?).first.new.files
    end

    def name; end
    alias :to_s :name
  end
end