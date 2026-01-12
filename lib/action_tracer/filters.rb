# frozen_string_literal: true

module ActionTracer
  APPLIED = { true => "APPLIED", false => "NO_APPLIED", unrecognized: "UNRECOGNIZED", action: "ACTION" }.freeze

  class Filter
    PROC = :Proc
    attr_reader :applied

    def initialize(filter, kind:, method:)
      @filter = filter.is_a?(Symbol) ? filter : PROC
      @kind = kind
      @method = method
      @applied = ActionTracer.applied_filters.include? filter
    end

    def to_a
      if @method.respond_to? :source_location
        source_location, line_number = *@method.source_location
        source_location = source_location&.sub(::ActionTracer.config.omitted_source_location_path, "")
        [APPLIED[@applied], @filter, source_location, line_number].compact
      else
        [APPLIED[:unrecognized], @method]
      end
    end

    def before?
      @kind == :before || @kind == :around
    end

    def after?
      @kind == :after || @kind == :around
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
      source_location, line_number = *@method.source_location
      source_location = source_location&.sub(::ActionTracer.config.omitted_source_location_path, "")
      [APPLIED[:action], @name, source_location, line_number].compact
    end

    def self.nil_method
      method(:p)
    end
    private_class_method :nil_method
  end

  class Filters
    def initialize(filters:, action:)
      @filters = filters
      @action = action
    end

    class << self
      def build(controller)
        raw_filters = controller.__callbacks[:process_action].__send__(:chain)
        filters = raw_filters.map do |raw_filter|
          filter = raw_filter.__send__(filter_method)
          Filter.new(
            filter,
            kind: raw_filter.kind,
            method: filter.is_a?(Symbol) ? controller.method(filter) : filter
          )
        end
        new(filters: filters, action: Action.build(controller))
      end

      private

      def filter_method
        @filter_method ||= Rails::VERSION::MAJOR > 6 ? :filter : :raw_filter
      end
    end

    def print
      invoked_before.map(&:to_a).each { |filter| ActionTracer.logger.info filter }
      ActionTracer.logger.info @action.to_a
      invoked_after.map(&:to_a).each { |filter| ActionTracer.logger.info filter }
    end

    private

    def invoked_before
      @filters.select(&:before?)
    end

    def invoked_after
      @filters.select(&:after?).reverse
    end
  end
end
