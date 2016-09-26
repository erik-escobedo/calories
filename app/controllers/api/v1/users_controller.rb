class Api::V1::UsersController < Api::V1::BaseController
  before_filter :require_account_ownership!
  before_filter :find_user, only: %i[update destroy]

  def  index
    render json: current_user.account.users
  end

  def create
    user = current_user.account.users.create(user_params)

    if user.valid?
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity #=> 422
    end
  end

  def update
    @user.update_attributes(user_params)

    if @user.valid?
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity #=> 422
    end
  end

  def destroy
    if @user.account_manager?
      render nothing: true, status: :method_not_allowed #=> 405
    else
      @user.destroy
      render nothing: true, status: :ok
    end
  end

private
  def find_user
    @user = current_user.account.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(%i[email password password_confirmation]) if params[:user].present?
  end

  def require_account_ownership!
    unless current_user.account_manager?
      render nothing: :true, status: :unauthorized #=> 401
    end
  end
end
