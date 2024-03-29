# frozen_string_literal: true

require "forwardable"

module ActionTracer
  class Railtie < ::Rails::Railtie
    initializer "action_tracer" do
      ActiveSupport.on_load(:action_controller) do
        require "action_tracer/monkey_patches/active_support/callbacks"
        if Rails::VERSION::MAJOR > 6
          [
            ::ActiveSupport::Callbacks::CallTemplate::MethodCall,
            ::ActiveSupport::Callbacks::CallTemplate::ObjectCall,
          ].each do |klass|
            klass.prepend ActionTracer::MonkeyPatches::ActiveSupport::Callbacks::CallTemplate::MethodCall
          end
          [
            ::ActiveSupport::Callbacks::CallTemplate::InstanceExec0,
            ::ActiveSupport::Callbacks::CallTemplate::InstanceExec1,
            ::ActiveSupport::Callbacks::CallTemplate::InstanceExec2,
          ].each do |klass|
            klass.prepend ActionTracer::MonkeyPatches::ActiveSupport::Callbacks::CallTemplate::InstanceExec
          end
          [
            ::ActiveSupport::Callbacks::CallTemplate::ProcCall,
          ].each do |klass|
            klass.prepend ActionTracer::MonkeyPatches::ActiveSupport::Callbacks::CallTemplate::ProcCall
          end
        else
          ::ActiveSupport::Callbacks::CallTemplate.prepend ActionTracer::MonkeyPatches::ActiveSupport::Callbacks::CallTemplate
        end

        require "action_tracer/monkey_patches/abstract_controller/callbacks"
        ::ActionController::Base.prepend ActionTracer::MonkeyPatches::AbstractController::Callbacks

        ActionTracer.config
      end
    end
  end
end
