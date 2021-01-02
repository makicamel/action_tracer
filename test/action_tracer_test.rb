# frozen_string_literal: true

require_relative 'test_helper'

class ActionTracerTest < ActionDispatch::IntegrationTest
  include MinitestHelper
  setup { File.write action_tracer_path, '' }

  test 'filters are in order' do
    get '/orders'
    assert_equal filters, [
      :before_1st, ActionTracer::APPLIED[true],
      :before_2nd, ActionTracer::APPLIED[true],
      :around_1st, ActionTracer::APPLIED[true],
      :around_2nd, ActionTracer::APPLIED[true],
      :index, ActionTracer::APPLIED[:action],
      :around_2nd, ActionTracer::APPLIED[true],
      :around_1st, ActionTracer::APPLIED[true],
      :after_2nd, ActionTracer::APPLIED[true],
      :after_1st, ActionTracer::APPLIED[true],
    ]
  end

  test 'excluded filter\'s status is NO_APPLIED' do
    get '/conditions'
    assert_equal filters, [
      :excluded, ActionTracer::APPLIED[false],
      :index, ActionTracer::APPLIED[:action],
    ]
  end

  test 'not called filter\'s status is NO_APPLIED' do
    get '/halts'
    assert_equal filters, [
      :halt_filter, ActionTracer::APPLIED[true],
      :not_called, ActionTracer::APPLIED[false],
      :index, ActionTracer::APPLIED[:action]
    ]
  end
end
