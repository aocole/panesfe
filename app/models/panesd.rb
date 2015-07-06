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

  def self.status
    resp = RestClient::Request.execute method: :get, url: API_BASE + '/status', timeout: 2
    return resp.body
  end

  def self.interactive_on
    RestClient::Request.execute method: :get, url: API_BASE + '/interactive/on', timeout: 10
  end

  def self.interactive_off
    RestClient::Request.execute method: :get, url: API_BASE + '/interactive/off', timeout: 10
  end


  private

  def logger
    Rails.logger
  end

end
