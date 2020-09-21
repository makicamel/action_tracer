# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  def self.caller
    @caller ||= TracePoint.new(:call) do |tp|
      if tp.defined_class.is_a?(ActionController::Base) && tp.binding.receiver.action_name == tp.method_id.to_s
        target = tp.binding.receiver
        filters = target.__callbacks[:process_action].send(:chain).map(&:filter)
        filters.each do |filter|
          # TODO: when filter is Proc, log line_no
          ActionTracer.logger.info target.method(filter).source_location.unshift(filter) if filter.is_a? Symbol
        end
      end
    end
  end
end