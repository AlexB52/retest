require_relative 'version_control/git'
require_relative 'version_control/no_version_control'

module Retest
  module VersionControl

    module_function

    def files
      [Git, NoVersionControl].find(&:installed?).files
    end
  end
end