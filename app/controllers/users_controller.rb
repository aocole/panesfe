class UsersController < ApplicationController
  before_action :set_user, except: [:settings]

  def settings
    @user = current_user
    authorize @user
    render :edit
  end

  def update
    respond_to do |format|
      @user.attributes = user_params
      if params[:user][:use_default_disk_quota] == "true"
        @user.custom_disk_quota_mb = nil
      end
      if @user.save
        format.html { redirect_to logged_in_home_path, notice: 'User settings updated successfully.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    respond_to do |format|
      if @user.save
        format.html { redirect_to logged_in_home_path, notice: I18n.t('controllers.users.password_changed') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    permitted_attributes(@user)
  end

  def set_user
    @user = policy_scope(User).find_by_id!(params[:id])
    authorize @user
  end
end
