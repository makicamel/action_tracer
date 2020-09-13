# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  def self.caller
    @caller ||= TracePoint.new(:call) do |tp|
      if FilePathChecker.app?(tp.path)
        log = "#{tp.method_id}@#{tp.path}:#{tp.lineno} #{tp.defined_class}"
        ActionTracer.logger.info log
        Rails.logger.info "[ACTION_TRACER] #{log}"
        caller.disable
        returner.enable
      end
    end
  end

  def self.returner
    @returner ||= TracePoint.new(:return) do |tp|
      # NOTE: ActiveSupport::Callbacks::CallTemplate is a private class
      if tp.method_id == :expand && tp.defined_class == ActiveSupport::Callbacks::CallTemplate
        returner.disable
        caller.enable
      end
    end
  end
end