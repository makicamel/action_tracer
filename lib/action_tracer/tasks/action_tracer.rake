# frozen_string_literal: true

# `rake action_tracer[welcome, get]`
desc 'Print all filters to be called'
task :action_tracer, [:path, :method] => :environment do |_, args|
  RakeApp.new('rake_app').exec(args[:path], args[:method])
end

class RakeApp < ActionDispatch::IntegrationTest
  DEFAULT_HOST = 'http://localhost/'

  def exec(path, method)
    case method
    when 'get'
      get DEFAULT_HOST + path
    when 'post'
      post DEFAULT_HOST + path
    when 'put'
      put DEFAULT_HOST + path
    when 'patch'
      patch DEFAULT_HOST + path
    when 'delete'
      delete DEFAULT_HOST + path
    else
      get DEFAULT_HOST + path
    end
  end
end
