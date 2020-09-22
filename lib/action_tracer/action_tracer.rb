# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  def self.logging(controller)
    filters = controller.__callbacks[:process_action].send(:chain).group_by(&:kind).map { |kind, callbacks| [kind, callbacks.map(&:filter)] }.to_h
    # TODO: when filter is Proc, log line_no
    log = -> (method) { ActionTracer.logger.info controller.method(method).source_location.unshift(method) if method.is_a? Symbol }
    [:before, :around].each { |key| filters[key].each(&log) }
    log.call(controller.action_name.to_sym)
    filters[:around].reverse_each(&log)
    filters[:after].each(&log)
    ActionTracer.logger.info ""
  end
end