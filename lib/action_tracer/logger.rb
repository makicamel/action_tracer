# frozen_string_literal: true

require "forwardable"

module ActionTracer
  class Logger < ActiveSupport::LogSubscriber
    extend Forwardable
    def_delegators :@logger, :info

    def initialize
      @logger = ::Logger.new(ActionTracer.config.path)
    end
  end

  def self.logger
    @logger ||= Logger.new
  end
end
