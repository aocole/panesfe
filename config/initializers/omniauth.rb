Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.google_oauth2_id, Rails.application.secrets.google_oauth2_secret
end
OmniAuth.config.logger = Rails.logger

