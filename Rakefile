# frozen_string_literal: true

# require 'bundler'
require 'bundler/gem_tasks'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task default: :test
