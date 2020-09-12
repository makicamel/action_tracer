# frozen_string_literal: true

require "forwardable"

module ActionTracer
  class Logger < ActiveSupport::LogSubscriber
    extend Forwardable
    def_delegators :@logger, :info

    def initialize(path: "action_tracer.log", directory: "log")
      path = Pathname.pwd + directory + path
      @logger = ::Logger.new(path)
    end
  end
end