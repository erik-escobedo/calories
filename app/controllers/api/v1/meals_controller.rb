class Api::V1::MealsController < Api::V1::BaseController
  before_filter :find_meal, only: %i[update destroy]

  def index
    meals = current_user.meals.filter(params)

    respond_with meals.order(:taken_at)
  end

  def create
    meal = current_user.meals.create(meal_params)

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
    params.require(:meal).permit(:taken_at, :calories, :description) if params[:meal].present?
  end

  def find_meal
    @meal = current_user.meals.find(params[:id])
  end
end
