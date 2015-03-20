class PresentationPolicy < ApplicationPolicy

  class Scope < Scope
  
    def resolve
      if user.user?
        scope.where(user: user)
      elsif user.admin? || user.superuser?
        scope.all
      end
    end

  end



end
