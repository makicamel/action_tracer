# frozen_string_literal: true

module ActionTracer
  class Error < StandardError; end

  class << self
    def log(controller)
      result = yield
      Filters.build(controller).print
      applied_filters.clear
      ActionTracer.logger.info ""

      result
    end

    def applied_filters
      @applied_filters ||= []
    end
  end
end
