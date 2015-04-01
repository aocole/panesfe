class AuthController < Devise::OmniauthCallbacksController
  skip_after_filter :verify_authorized, only: [:google_oauth2]

  def google_oauth2
    @user = User.find_or_create_with_omniauth(auth_hash)
    sign_in_and_redirect @user, event: :authentication
  end
  
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
