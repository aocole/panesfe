module CurrentUserHelper
  def user_not_authorized
    unless request.xhr?
      # TODO: more descriptive error? LESS descriptive? Should this be a 404 instead?
      flash[:alert] = t('controllers.auth.not_authorized')
    end
    redirect_to(logged_in_home_path)
  end
end
