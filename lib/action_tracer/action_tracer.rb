# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class << self
    def returner
      @returner ||= TracePoint.new(:return) do |tp|
        if tp.method_id == :expand && tp.defined_class == ActiveSupport::Callbacks::CallTemplate
          # target, block, method, *arguments = result
          applied_filters << tp.return_value[2] if tp.return_value.fetch(2) { nil }
        end
      end
    end

    def logging(controller)
      filters = controller.__callbacks[:process_action]
        .send(:chain).group_by(&:kind)
        .map { |kind, callbacks|
          [
            kind,
            callbacks.map(&:filter).delete_if { |callback| applied_filters.exclude? callback }
          ]
        }.to_h
      # TODO: when filter is Proc, log line_no
      log = -> (method) { ActionTracer.logger.info controller.method(method).source_location.unshift(method) if method.is_a? Symbol }
      [:before, :around].each { |kind| filters[kind].each(&log) }
      log.call(controller.action_name.to_sym)
      filters[:around].reverse_each(&log)
      filters[:after].each(&log)
      ActionTracer.logger.info ""
    end

    private

    def applied_filters
      @applied_filters ||= []
    end
  end
end