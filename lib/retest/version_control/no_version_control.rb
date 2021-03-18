class Retest::VersionControl
  class NoVersionControl
    def self.installed?
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