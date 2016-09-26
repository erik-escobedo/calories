class Api::V1::Admin::MealsController < Api::V1::BaseController
  before_filter :require_admin!
  before_filter :find_meal, only: %i[update destroy]

  def index
    meals = Meal.all

    respond_with meals
  end

  def create
    meal = Meal.create(meal_params)

    if meal.valid?
      render json: meal
    else
      render json: { errors: meal.errors.full_messages }, status: :unprocessable_entity #=> 422
    end
  end

  def update
    @meal.update(meal_params)

    if @meal.valid?
      render json: @meal
    else
      render json: { errors: @meal.errors.full_messages }, status: :unprocessable_entity #=> 422
    end
  end

  def destroy
    @meal.destroy

    render nothing: true, status: :ok
  end

private
  def meal_params
    params.require(:meal).permit(:user_id, :taken_at, :calories, :description) if params[:meal].present?
  end

  def find_meal
    @meal = Meal.find(params[:id])
  end
end
