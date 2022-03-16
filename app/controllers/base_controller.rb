class BaseController < ApplicationController
  def home
    @packages = %w[Bootstrap FontAwesome]
  end
end
