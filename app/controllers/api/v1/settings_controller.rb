class Api::V1::SettingsController < Api::V1::BaseController
  def update
    settings = current_user.settings
    settings.update(settings_params)

    if settings.valid?
      render nothing: true, status: :ok
    else
      render json: { errors: settings.errors.full_messages }, status: :unprocessable_entity #=> 422
    end
  end

private
  def settings_params
    params.require(:settings).permit(:daily_calories)
  end
end
