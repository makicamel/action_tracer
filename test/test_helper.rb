# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rails'
require 'byebug'
require 'minitest/autorun'
require 'action_tracer'

ENV['RAILS_ENV'] ||= 'test'

module ActionTracerTestApp
  class Application < Rails::Application; end
end

ActionTracerTestApp::Application.initialize!
