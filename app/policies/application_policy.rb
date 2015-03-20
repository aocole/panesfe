class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    admin_or_owner
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    admin_or_owner
  end

  def edit?
    update?
  end

  def destroy?
    admin_or_owner
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def admin_or_owner
    record.user == user || user.admin? || user.superuser?
  end

end
