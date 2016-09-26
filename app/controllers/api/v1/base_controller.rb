class Api::V1::BaseController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

protected
  def require_admin!
    unless current_user.admin?
      render nothing: :true, status: :unauthorized #=> 401
    end
  end
end
