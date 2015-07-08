class GlobalSettingsController < ApplicationController

  def edit
    authorize :global_settings, :edit?
  end

  def update
    authorize :global_settings, :update?
    if params[:interactive_mode]
      Panesd.interactive_on
    else
      Panesd.interactive_off
    end
    redirect_to logged_in_home_path
  rescue Errno::ECONNREFUSED
    redirect_to global_settings_path
  end

end
