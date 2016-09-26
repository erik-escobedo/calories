class Api::V1::Admin::UsersController < Api::V1::BaseController
  before_filter :require_admin!
  before_filter :find_user, only: %i[update destroy]

  def  index
    users = User.all

    render json: users
  end

  def create
    user = User.create(user_params)

    if user.valid?
      render json: user
    else
      render json: { errors: user.errors }, status: :unprocessable_entity #=> 422
    end
  end

  def update
    @user.update_attributes(user_params)

    if @user.valid?
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity #=> 422
    end
  end

  def destroy
    if current_user == @user
      render nothing: true, status: :method_not_allowed #=> 405
    else
      if @user.account_manager?
        @user.account.destroy
      else
        @user.destroy
      end

      render nothing: true, status: :ok
    end
  end

private
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(%i[email password password_confirmation]) if params[:user].present?
  end
end
