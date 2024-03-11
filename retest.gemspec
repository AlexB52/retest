require_relative 'lib/retest/version'

Gem::Specification.new do |spec|
  spec.name          = "retest"
  spec.version       = Retest::VERSION
  spec.authors       = ["Alexandre Barret"]
  spec.email         = ["alex@abletech.nz"]

  spec.summary       = "A simple command line tool to watch file change and run its matching spec."
  spec.homepage      = "https://github.com/AlexB52/retest"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/AlexB52/retest"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "string-similarity", ["~> 2.1"]
  spec.add_runtime_dependency "listen", ["~> 3.9"]
  spec.add_runtime_dependency "tty-option", ["~> 0.1"]
  spec.add_runtime_dependency "observer", ["~> 0.1"]
end
