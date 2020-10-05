# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module ActiveSupport
      module Callbacks
        module CallTemplate
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
