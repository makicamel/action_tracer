# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  callback_caller = nil

  TracePoint.trace(:call) do |tp|
    if callback_caller
      if FilePathChecker.app?(tp.path)
        log = "#{tp.method_id}@#{tp.path}:#{tp.lineno} #{tp.defined_class}"
        ActionTracer.logger.info log
        Rails.logger.info "[ACTION_TRACER] #{log}"
        callback_caller = nil
      end
    end
  end

  TracePoint.trace(:return) do |tp|
    # NOTE: ActiveSupport::Callbacks::CallTemplate is a private class
    if tp.method_id == :expand && tp.defined_class == ActiveSupport::Callbacks::CallTemplate
      callback_caller = tp.return_value.last
    end
  end
end