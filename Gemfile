# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in action_tracer.gemspec
gemspec

rails_version = ENV["RAILS_VERSION"]
if rails_version
  version = "~> #{rails_version}"
  %w[actionpack activesupport railties].each do |gem_name|
    gem gem_name, version
  end
else
  %w[actionpack activesupport railties].each do |gem_name|
    gem gem_name
  end
end
