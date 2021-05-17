module Retest
  module FileSystem
    module_function

    def exist?(value)
      File.exist? value
    end
  end
end
