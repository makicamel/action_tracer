
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_tracer/version"

Gem::Specification.new do |spec|
  spec.name        = "action_tracer"
  spec.version     = ActionTracer::VERSION
  spec.authors     = ["makicamel"]
  spec.email       = ["unright@gmail.com"]
  spec.homepage    = "https://github.com/makicamel/action_tracer"
  spec.summary     = "Show Rails actions and filter chains"
  spec.description = "Show Rails actions and filter chains"
  spec.license     = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://github.com/makicamel/action_tracer"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "https://github.com/makicamel/action_tracer/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
