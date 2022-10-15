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

      def files
        Dir.glob('**/*') - Dir.glob('{tmp,node_modules}/**/*')
      end
    end
  end
end
