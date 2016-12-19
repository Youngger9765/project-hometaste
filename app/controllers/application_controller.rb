class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :new_user

	protected

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number])
  end

  def user_not_authorized(exception)
    redirect_to root_path  # 導向筆者剛剛新增的網頁
  end

  def new_user
  @user = User.new
  end

  def user_admin?
    if current_user.is_admin?
    else
      redirect_to root_path
    end
  end
end
