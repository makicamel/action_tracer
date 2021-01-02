# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'action_controller/railtie'
require 'byebug'
require 'minitest/autorun'
require 'action_tracer'
require_relative 'fake_app'

ENV['RAILS_ENV'] ||= 'test'

module ActionTracerTestApp
  class Application < Rails::Application
    config.root = __dir__
  end
end

ActionTracerTestApp::Application.initialize!

module MinitestHelper
  def action_tracer_path
    @action_tracer_path ||= File.expand_path('../log/action_tracer.log', __dir__)
  end

  end
end
