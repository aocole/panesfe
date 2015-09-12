class UserPolicy < ApplicationPolicy

  def create?
    user.adminish?
  end

  def settings?
    record == user
  end

  def show?
    # must be admin, and can't delete yourself
    user.adminish? && record != user
  end

  def edit?
    show?
  end

  def password?
    settings? && record.provider == "devise"
  end

  def password_update?
    password?
  end

  def update?
    edit? || settings?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    return [] unless admin_or_owner?
    
    permitted = [:family_name, :given_name, :primary_presentation_id]
    if user.adminish?
      permitted += [:custom_disk_quota_mb, :card_number]
      if record != user
        permitted += [:role]
        if record.new_record?
          permitted += [:email]
        end
      end
    end

    if record.provider == "devise"
      permitted += [:password, :password_confirmation]
    end

    return permitted
  end

  class Scope < Scope
  
    def resolve
      if user.adminish?
        scope.all
      else
        scope.where(id: user.id)
      end
    end

  end

  private

  def admin_or_owner?
    record == user || user.adminish?
  end

end
