class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
    :rememberable, 
    :trackable, 
    :validatable,
    :omniauthable,
    omniauth_providers: [:google_oauth2]
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :role, presence: true

  enum role: {
    user: 0, 
    admin: 100, 
    superuser: 200
  }

  def adminish?
    admin? || superuser?
  end

  def videowall?
    false
  end

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

  protected

  # we don't want to force passwords on the normal case of 
  # signing in with google
  def password_required?
    return false if provider.to_s == 'google_oauth2'
    super
  end

end
