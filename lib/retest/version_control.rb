require_relative 'version_control/git'
require_relative 'version_control/no_version_control'

module Retest
  module VersionControl

    module_function

    def files(extensions: [])
      [Git, NoVersionControl].find(&:installed?).files(extensions: extensions)
    end
  end
end