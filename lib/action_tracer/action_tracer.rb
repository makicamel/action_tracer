# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class Request
    def initialize(controller)
      @controller = controller
      @callback_chain = controller.__callbacks[:process_action].send(:chain)
    end

    def log
      returner.enable
      result = yield
      returner.disable
      logging
      applied_filters.clear
      result
    end

    private

    def returner; ActionTracer.returner; end
    def applied_filters; ActionTracer.applied_filters; end

    def logging
      filters = @callback_chain.group_by(&:kind)
        .map { |kind, callbacks|
          [
            kind,
            callbacks.map(&:filter).delete_if { |callback| applied_filters.exclude? callback }
          ]
        }.to_h
      # TODO: when filter is Proc, log line_no
      log = -> (method) { ActionTracer.logger.info @controller.method(method).source_location.unshift(method) if method.is_a? Symbol }
      [:before, :around].each { |kind| filters[kind].each(&log) }
      log.call(@controller.action_name.to_sym)
      filters[:around].reverse_each(&log)
      filters[:after].each(&log)
      ActionTracer.logger.info ""
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