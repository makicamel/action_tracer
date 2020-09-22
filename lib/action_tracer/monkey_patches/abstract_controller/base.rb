# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module AbstractController
      module Base
        private

        # Monkey patch to log filters
        def process_action(action, *args)
          super.tap { logging }
        end

        def logging
          filters = __callbacks[:process_action].send(:chain).group_by(&:kind).map { |kind, callbacks| [kind, callbacks.map(&:filter)] }.to_h
          # TODO: when filter is Proc, log line_no
          log = -> (method) { ActionTracer.logger.info method(method).source_location.unshift(method) if method.is_a? Symbol }
          [:before, :around].each { |key| filters[key].each(&log) }
          filters[:around].reverse_each(&log)
          filters[:after].each(&log)
          ActionTracer.logger.info ""
        end
      end
    end
  end
end
