class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  after_action :verify_authorized, :except => [:index, :show]
  after_action :verify_policy_scoped, :only => [:index, :show]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include CurrentUserHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  def not_found
    redirect_to not_found_path
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || logged_in_home_path
  end

  def after_sign_out_path_for(resource)
    logged_out_home_path
  end
end
