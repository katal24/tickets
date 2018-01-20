class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :phone, :cash)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :phone, :cash, :current_password)
  end
end