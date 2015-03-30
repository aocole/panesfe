class Panesd
  API_BASE = 'http://localhost:3001'

  def initialize(display_url)
    @display_url = display_url
  end

  def push
    push_url = @display_url.sub('//', '/')
    logger.debug "Sending #{push_url.inspect}"
    RestClient.get [API_BASE, '/navigate/', push_url].join
    return true
  end

  private

  def logger
    Rails.logger
  end

end
