# frozen_string_literal: true

require "forwardable"

module ActionTracer
  class Config
    attr_reader :path

    def initialize(directory:, file:)
      @path = directory + file
    end
  end

  def self.app_path
    @app_path ||= Dir.pwd
  end

  def self.config(directory: "/log/", file: "action_tracer.log")
    @config ||= Config.new(directory: app_path + directory, file: file)
  end

  class Railtie < ::Rails::Railtie
    initializer "action_tracer" do
      ActiveSupport.on_load(:action_controller) do
        require "action_tracer/monkey_patches/active_support/callbacks"
        ::ActiveSupport::Callbacks::CallTemplate.prepend ActionTracer::MonkeyPatches::ActiveSupport::Callbacks::CallTemplate
        require "action_tracer/monkey_patches/abstract_controller/callbacks"
        ::ActionController::Base.prepend ActionTracer::MonkeyPatches::AbstractController::Callbacks

        ActionTracer.config
      end
    end

    rake_tasks do
      load "#{__dir__}/tasks/action_tracer.rake"
    end
  end
end
