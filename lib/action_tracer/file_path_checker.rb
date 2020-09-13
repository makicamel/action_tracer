# frozen_string_literal: true

module ActionTracer
  module FilePathChecker
    def self.app?(path)
      path.include? ActionTracer.app_path
    end
  end
end