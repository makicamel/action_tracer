$:.push File.expand_path("../lib", __FILE__)

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
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.1.7"
end
