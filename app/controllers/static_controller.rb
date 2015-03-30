class StaticController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  
  def about
  end

  def not_found
  end
end
