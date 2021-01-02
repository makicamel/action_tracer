# frozen_string_literal: true

require_relative 'test_helper'

class ActionTracerTest < ActionDispatch::IntegrationTest
  include MinitestHelper
  setup { File.write action_tracer_path, '' }

  end
end
