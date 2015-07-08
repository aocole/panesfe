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
  validate :primary_presentation_belongs_to_user

  has_many :presentations

  belongs_to :primary_presentation, class_name: 'Presentation'

  enum role: {
    user: 0, 
    admin: 100, 
    superuser: 200
  }

  def adminish?
    admin? || superuser?
  end

  def primary_presentation_belongs_to_user
    if primary_presentation && primary_presentation.user.id != self.id 
      errors.add(:primary_presentation_id, :must_belong_to_user)
    end
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

  def disk_used_b
    return 0 unless upload_eligible?
    return 0 unless Dir.exist?(absolute_upload_path)
    # gets usage in kb then calculates mb. User gets 4k credit for dir size
    (`du -sb "#{absolute_upload_path}"`.split("\t").first.to_i - 4.kilobytes).to_f
  end

  def disk_used_mb
    disk_used_b / 1.megabyte
  end

  def disk_available_mb
    return 0 unless upload_eligible?
    disk_quota_mb - disk_used_mb
  end

  def disk_available_b
    disk_available_mb.megabytes
  end

  def disk_quota_mb
    custom_disk_quota_mb || GrowingPanes.config['default_disk_quota_mb']
  end

  def self.upload_base
    if GrowingPanes.config['upload_url_prefix'].blank?
      return Rails.env
    end
    File.join(GrowingPanes.config['upload_url_prefix'], Rails.env)
  end

  def upload_dir
    raise "Unsaved users can't have an upload_dir" unless upload_eligible?
    File.join(self.class.upload_base, "user_#{id}")
  end

  def absolute_upload_path
    File.join BaseUploader.root.call, upload_dir
  end

  def ensure_upload_dir
    FileUtils.mkdir_p(absolute_upload_path)
  end

  def upload_eligible?
    !id.nil?
  end

  protected

  # we don't want to force passwords on the normal case of 
  # signing in with google
  def password_required?
    return false if provider.to_s == 'google_oauth2'
    super
  end

end
