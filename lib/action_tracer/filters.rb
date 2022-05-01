# frozen_string_literal: true

module ActionTracer
  APPLIED = { true => "APPLIED", false => "NO_APPLIED", unrecognized: "UNRECOGNIZED", action: "ACTION" }.freeze

  class Filter
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
        [APPLIED[:unrecognized], @method]
      end
    end
  end

  class Action
    def initialize(name:, method:)
      @name = name
      @method = method
    end

    def self.build(controller)
      method = controller.respond_to?(controller.action_name) ? controller.method(controller.action_name) : nil_method
      new(name: controller.action_name, method: method)
    end

    def to_a
      [APPLIED[:action], @name, *@method.source_location]
    end

    def self.nil_method
      method(:p)
    end
    private_class_method :nil_method
  end

  class Filters
    def initialize(before = [], after = [], around = [], action:)
      @before = before
      @after = after
      @around = around
      @action = action
    end

    class << self
      def build(controller)
        filters = { before: [], after: [], around: [] }
        raw_filters = controller.__callbacks[:process_action].send(:chain).group_by(&:kind)
        raw_filters.each do |kind, filter|
          filters[kind] = filter.map(&:raw_filter).map do |f|
            Filter.new(f, method: f.is_a?(Symbol) ? controller.method(f) : f)
          end
        end
        new(filters[:before], filters[:after], filters[:around], action: Action.build(controller))
      end
    end

    def print
      invoked_before.map(&:to_a).each { |filter| ActionTracer.logger.info filter }
      ActionTracer.logger.info @action.to_a
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
