# frozen_string_literal: true

require_relative "test_helper"

class ActionTracerTest < ActionDispatch::IntegrationTest
  include MinitestHelper
  setup { File.write action_tracer_path, "" }

  test "filters are in order" do
    get "/orders"
    assert_equal [
      :before_1st, ActionTracer::APPLIED[true],
      :around_1st, ActionTracer::APPLIED[true],
      :before_2nd, ActionTracer::APPLIED[true],
      :around_2nd, ActionTracer::APPLIED[true],
      :index, ActionTracer::APPLIED[:action],
      :around_2nd, ActionTracer::APPLIED[true],
      :after_2nd, ActionTracer::APPLIED[true],
      :after_1st, ActionTracer::APPLIED[true],
      :around_1st, ActionTracer::APPLIED[true],
    ], filters
  end

  test "excluded filter's status is NO_APPLIED" do
    get "/conditions"
    assert_equal [
      :excluded, ActionTracer::APPLIED[false],
      :index, ActionTracer::APPLIED[:action],
    ], filters
  end

  test "an undefined action log is output" do
    get "/undefined_methods"
    assert_equal [
      :before, ActionTracer::APPLIED[true],
      :index, ActionTracer::APPLIED[:action],
    ], filters
  end

  test "not called filter's status is NO_APPLIED" do
    get "/halts"
    assert_equal [
      :halt_filter, ActionTracer::APPLIED[true],
      :not_called, ActionTracer::APPLIED[false],
      :index, ActionTracer::APPLIED[:action]
    ], filters
  end

  test "to return filters even when redirected before action is called" do
    get "/redirects"
    assert_equal [
      :redirect, ActionTracer::APPLIED[true],
      :index, ActionTracer::APPLIED[:action],
      :not_called, ActionTracer::APPLIED[false]
    ], filters
  end

  test "to return filters even when action raise error" do
    get "/exceptions"
    assert_equal [
      :before1, ActionTracer::APPLIED[true],
      :index, ActionTracer::APPLIED[:action]
    ], filters
  end
end
