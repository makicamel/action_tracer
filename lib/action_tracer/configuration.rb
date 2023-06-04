# frozen_string_literal: true

module ActionTracer
  class Configration
    attr_writer :app_path, :directory, :file_name, :logger, :omitted_source_location_paths

    def app_path
      @app_path ||= Dir.pwd
    end

    def directory
      @directory ||= '/log/'
    end

    def file_name
      @file_name ||= 'action_tracer.log'
    end

    def logger
      @logger ||= Logger.new(app_path + directory + file_name)
    end

    def omitted_source_location_paths
      @omitted_source_location_paths ||= ["#{Dir.pwd}/"]
    end

    def omitted_source_location_path
      @omitted_source_location_path ||= %r{#{omitted_source_location_paths.join('|')}}
    end
  end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configration.new
    end

    def logger
      @logger ||= @config.logger
    end
  end
end
