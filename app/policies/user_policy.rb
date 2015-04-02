class UserPolicy < ApplicationPolicy

  class Scope < Scope
  
    def resolve
      if user.adminish?
        scope.all
      else
        scope.where(id: user.id)
      end
    end

  end
end
