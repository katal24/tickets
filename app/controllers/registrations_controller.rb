class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :phone, :cash, :birth)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :phone, :cash, :birth, :current_password)
  end
end