# frozen_string_literal: true

module ActionTracer
  class Filter
    APPLIED = { true => "APPLIED", false => "NO_APPLIED" }.freeze

    def initialize(filter, method:)
      @filter = filter
      @method = method
      @applied = ActionTracer.applied_filters.include? filter
    end

    def print
      ActionTracer.logger.info [APPLIED[@applied], @filter, *@method.source_location]
    end
  end

  class Filters
    def initialize(before = [], after = [], around = [], action:)
      @before = before
      @after = after
      @around = around
      @action = action
    end

    def self.build(controller)
      filters = { before: [], after: [], around: [] }
      raw_filters = controller.__callbacks[:process_action].send(:chain).group_by(&:kind)
      raw_filters.each do |kind, filter|
        filters[kind] = filter.map(&:raw_filter).map do |f|
          Filter.new(f, method: f.is_a?(Symbol) ? controller.method(f) : f)
        end
      end
      new(filters[:before], filters[:after], filters[:around], action: controller.method(controller.action_name))
    end

    def print
      invoked_before.each { |filters| filters.each(&:print) }
      # printer.call(@action)
      invoked_after.each { |filters| filters.reverse_each(&:print) }
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
