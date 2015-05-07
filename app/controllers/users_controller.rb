class UsersController < ApplicationController

  private

  def user_params
    permitted_attributes(@user)
  end
end
