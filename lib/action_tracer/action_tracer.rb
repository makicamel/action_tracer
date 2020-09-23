# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  def self.returner
    @returner ||= TracePoint.new(:return) do |tp|
      if tp.method_id == :expand && tp.defined_class == ActiveSupport::Callbacks::CallTemplate
        return_value = tp.return_value
        if return_value.is_a?(Array) && return_value.fetch(2) { nil }
          # target, block, method, *arguments = result
          callbacks << return_value[2]
        end
      end
    end
  end

  def self.logging(controller)
    filters = controller.__callbacks[:process_action]
      .send(:chain).group_by(&:kind)
      .map { |kind, callbacks|
        [
          kind,
          callbacks.map(&:filter).delete_if { |callback| self.callbacks.exclude? callback }
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

  def self.callbacks
    @callbacks ||= []
  end
end