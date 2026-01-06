# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_tracer/version"

Gem::Specification.new do |spec|
  spec.name        = "action_tracer"
  spec.version     = ActionTracer::VERSION
  spec.authors     = ["makicamel"]
  spec.email       = ["unright@gmail.com"]
  spec.homepage    = "https://github.com/makicamel/action_tracer"
  spec.summary     = "Log Rails application actions and filters when accepts a request"
  spec.description = "Log Rails application actions and filters when accepts a request"
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "actionpack"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
