class GlobalSettingPolicy < Struct.new(:user, :global_settings)

  def edit?
    user.adminish?
  end

  def update?
    edit?
  end

end
