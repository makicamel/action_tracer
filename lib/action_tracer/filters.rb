# frozen_string_literal: true

module ActionTracer
  class Filter
    APPLIED = { true => "APPLIED", false => "NO_APPLIED" }.freeze
    PROC = :Proc
    attr_reader :applied

    def initialize(filter, method:)
      @filter = filter.is_a?(Symbol) ? filter : PROC
      @method = method
      @applied = ActionTracer.applied_filters.include? filter
    end

    def to_a
      if @method.respond_to? :source_location
        [APPLIED[@applied], @filter, *@method.source_location]
      else
        ["UNRECOGNIZED", @method]
      end
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
      invoked_before.map(&:to_a).each { |filter| ActionTracer.logger.info filter }
      ActionTracer.logger.info ["ACTION", @action.name, *@action.source_location]
      invoked_after.map(&:to_a).reverse_each { |filter| ActionTracer.logger.info filter }
    end

    private

    def invoked_before
      @before + @around
    end

    def invoked_after
      @after + @around
    end
  end
end
