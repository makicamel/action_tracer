# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class << self
    def log(controller)
      filter_collector.enable
      result = yield
      filter_collector.disable
      Filters.build(controller).print
      applied_filters.clear
      ActionTracer.logger.info ""

      result
    end

    def filter_collector
      @filter_collector ||= TracePoint.new(:return) do |tp|
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