class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :role, presence: true

  enum role: {
    user: 0, 
    admin: 100, 
    superuser: 200
  }

  def self.find_or_create_with_omniauth(auth)
    find_by(uid: auth["uid"], provider: auth["provider"]) ||
    create!(
      provider:   auth["provider"],
      uid:        auth["uid"],
      given_name: auth["info"]["given_name"] || auth["info"]["first_name"],
      family_name:auth["info"]["family_name"] || auth["info"]["last_name"],
      email:      auth["info"]["email"],
      role:       User.roles["user"]
    )
  end

end
