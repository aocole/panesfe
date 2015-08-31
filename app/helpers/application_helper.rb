module ApplicationHelper
  def interactive_mode_warning
    return '' unless interactive_mode?
    return <<-END.html_safe
      <div class="alert alert-warning alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        #{t('controllers.settings.interactive_mode_warning')}
      </div>
      END
  rescue Errno::ECONNREFUSED
    return <<-END.html_safe
      <div class="alert alert-danger alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        #{t('controllers.presentations.panesd_offline')}
      </div>
      END

  end

  # Makes an HTTP call to the panesd status url
  def interactive_mode?
    # Since this method gets run every time the app renders, we generally don't want
    # to actually make the http call since it requires a lot of jiggery with VCR
    if Rails.env == 'test' && !GrowingPanes.config[:test_interactive_mode]
      return false
    end

    return (Panesd.status =~ /Interactive Mode: On/) != nil
  end

end
