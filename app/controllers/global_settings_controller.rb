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

  def screens_on
    screen_state 'on'
  end

  def screens_off
    screen_state 'off'
  end

  private

  def screen_state(state)
    authorize :global_settings, "screens_#{state}?".intern
    `displays_#{state}.sh`
    flash[:notice] = t('controllers.settings.screens_signaled')
    if request.env['HTTP_REFERER']
      redirect_to :back
    else
      redirect_to logged_in_home_path
    end
  end    

end
