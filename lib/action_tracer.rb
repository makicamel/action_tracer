require "action_tracer/version"
require "action_tracer/file_type_checker"

module ActionTracer
  class Error < StandardError; end

  callback_caller = nil
  file_type_checker = FileTypeChecker.new

  TracePoint.trace(:call) do |tp|
    if callback_caller
      unless file_type_checker.libraly?(tp.path)
        puts "-> #{tp.method_id}@#{tp.path}:#{tp.lineno} #{tp.defined_class}"
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