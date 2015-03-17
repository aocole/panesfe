class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, :except => [:index, :show]
  after_action :verify_policy_scoped, :only => [:index, :show]
  before_filter :require_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include CurrentUserHelper
end
