# frozen_string_literal: true

class OrdersController < ActionController::Base
  before_action :before_1st
  around_action :around_1st
  before_action :before_2nd
  after_action :after_1st
  after_action :after_2nd
  around_action :around_2nd

  def index
    render json: {}, status: 200
  end

  private

  def before_1st; end
  def before_2nd; end
  def around_1st; yield; end
  def around_2nd; yield; end
  def after_1st; end
  def after_2nd; end
end

class ConditionsController < ActionController::Base
  before_action :excluded, except: :index

  def index
    render json: {}, status: 200
  end

  private

  def excluded; end
end

class UndefinedMethodsController < ActionController::Base
  before_action :before

  private

  def before; end
end

class HaltsController < ActionController::Base
  before_action :halt_filter
  before_action :not_called

  def index
    render json: {}, status: 200
  end

  private

  def halt_filter; render json: {}, status: 400; end
  def not_called; end
end

class RedirectsController < ActionController::Base
  before_action :redirect
  after_action :not_called

  def index; end

  private

  def redirect
    redirect_to "/orders"
  end

  def not_called; end
end

class ExceptionsController < ActionController::Base
  before_action :before

  def index
    raise RuntimeError
  end

  private

  def before; end
end
