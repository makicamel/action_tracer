# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module ActiveSupport
      module Callbacks
        module CallTemplate
          if Rails::VERSION::MAJOR > 6
            module MethodCall
              def expand(*)
                super.tap { ActionTracer.applied_filters << @method_name }
              end

              def make_lambda
                super >> proc { |result| ActionTracer.applied_filters << @method_name; result }
              end

              def inverted_lambda
                super >> proc { |result| ActionTracer.applied_filters << @method_name; result }
              end
            end

            module ProcCall
              def expand(*)
                super.tap { ActionTracer.applied_filters << @override_target }
              end

              def make_lambda
                super >> proc { |result| ActionTracer.applied_filters << @override_target; result }
              end

              def inverted_lambda
                super >> proc { |result| ActionTracer.applied_filters << @override_target; result }
              end
            end

            module InstanceExec
              def expand(*)
                super.tap { ActionTracer.applied_filters << @override_block }
              end

              def make_lambda
                super >> proc { |result| ActionTracer.applied_filters << @override_block; result }
              end

              def inverted_lambda
                super >> proc { |result| ActionTracer.applied_filters << @override_block; result }
              end
            end
          else
            def expand(*)
              target, block, method, *arguments = super
              if target.is_a? ActionController::Base
                case method
                when :instance_exec # filter is a proc
                  ActionTracer.applied_filters << block
                when String         # filter is an object
                  ActionTracer.applied_filters << block
                when Symbol         # filter is a method
                  ActionTracer.applied_filters << method
                end
              end

              [target, block, method, *arguments]
            end
          end
        end
      end
    end
  end
end
