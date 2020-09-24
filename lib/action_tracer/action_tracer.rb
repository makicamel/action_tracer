# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class Request
    def initialize(controller)
      @controller = controller
    end

    def log
      ActionTracer.returner.enable
      result = yield
      ActionTracer.returner.disable
      Filters.build(@controller).print
      ActionTracer.applied_filters.clear
      ActionTracer.logger.info ""
      result
    end
  end

  class << self
    def returner
      @returner ||= TracePoint.new(:return) do |tp|
        # NOTE: ActiveSupport::Callbacks::CallTemplate is a private class
        if tp.method_id == :expand && tp.defined_class == ActiveSupport::Callbacks::CallTemplate
          # target, block, method, *arguments = result
          applied_filters << tp.return_value[2] if tp.return_value.fetch(2) { nil }
        end
      end
    end

    def applied_filters
      @applied_filters ||= []
    end
  end
end