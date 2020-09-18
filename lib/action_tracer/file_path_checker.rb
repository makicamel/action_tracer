# frozen_string_literal: true

module ActionTracer
  module FilePathChecker
    def self.filter?
      ActionTracer.callback_called?
    end

    def self.app?(path)
      path.start_with? ActionTracer.app_path
    end

    def self.app_controller?(path)
      path.start_with? "#{ActionTracer.app_path}/app/controllers"
    end
  end
end
