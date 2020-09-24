# frozen_string_literal: true

module ActionTracer
  module ActionControllerExt
    # TODO: Use ActionController::Base or ActionController::API
    refine AbstractController::Base do
      def source_for(filter)
        case filter
        when Symbol
          method(filter).source_location.unshift(filter)
        when Proc
          # TODO: when filter is Proc, log line_no
        end
      end
    end
  end

  class Filters
    using ActionTracer::ActionControllerExt

    def initialize(controller, before: [], after: [], around: [])
      @controller = controller
      @before = before
      @after = after
      @around = around
    end

    def self.build(controller)
      callback_chain = controller.__callbacks[:process_action].send(:chain)
      filters = callback_chain
        .group_by(&:kind)
        .map { |kind, callbacks| [kind, callbacks.map(&:filter) & ActionTracer.applied_filters] }
        .to_h
      new(controller, before: filters[:before], after: filters[:after], around: filters[:around])
    end

    def print
      printer = -> (filter) { ActionTracer.logger.info @controller.source_for(filter) }
      invoked_before.each { |filters| filters.each { |filter| printer.call(filter) } }
      printer.call(@controller.action_name.to_sym)
      invoked_after.each { |filters| filters.reverse_each { |filter| printer.call(filter) } }
    end

    private

    def invoked_before
      [@before, @around]
    end

    def invoked_after
      [@around, @after]
    end
  end
end
