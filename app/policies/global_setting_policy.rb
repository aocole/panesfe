class GlobalSettingPolicy < Struct.new(:user, :global_settings)

  def edit?
    user.adminish?
  end

  def update?
    edit?
  end

  def screens_on?
    user.adminish?
  end

  def screens_off?
    screens_on?
  end

end
