# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class << self
    def log(controller)
      result = yield
    ensure
      Filters.build(controller).print
      applied_filters.clear
      ActionTracer.logger.info ""

      result
    end

    def applied_filters
      @applied_filters ||= []
    end

    def wrap_callbacks(controller)
      klass = controller.class
      @wrapped_classes ||= []
      return if @wrapped_classes.include?(klass)

      filter_method = Rails::VERSION::MAJOR > 6 ? :filter : :raw_filter
      raw_filters = controller.__callbacks[:process_action].__send__(:chain)
      klass.prepend(
        Module.new do
          raw_filters.each do |raw_filter|
            filter = raw_filter.__send__(filter_method)
            next unless filter.is_a?(Symbol)

            define_method(filter) do |*args, &block|
              ActionTracer.applied_filters << filter
              super(*args, &block)
            end
          end
        end
      )

      @wrapped_classes << klass
    end
  end
end
