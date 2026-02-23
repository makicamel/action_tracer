# frozen_string_literal: true

require "forwardable"

module ActionTracer
  class Railtie < ::Rails::Railtie
    initializer "action_tracer" do
      ActiveSupport.on_load(:action_controller) do
        require "action_tracer/monkey_patches/abstract_controller/callbacks"
        ::ActionController::Base.prepend ActionTracer::MonkeyPatches::AbstractController::Callbacks

        ActionTracer.config
      end
    end
  end
end
