# frozen_string_literal: true

class FooController < ActionController::Base
  def index
    render json: {}, status: 200
  end
end