module Retest
  module VersionControl
    module NoVersionControl

      module_function

      def installed?
        true
      end

      def name
        'default'
      end

      def files(extensions: [])
        result = if extensions.empty?
          Dir.glob('**/*')
        else
          Dir.glob("**/*.{#{extensions.join(',')}}")
        end

        result - Dir.glob('{tmp,node_modules}/**/*')
      end
    end
  end
end
