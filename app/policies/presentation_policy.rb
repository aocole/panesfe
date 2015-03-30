class PresentationPolicy < ApplicationPolicy

  def push?
    user.adminish?
  end

  class Scope < Scope
  
    def resolve
      if user.user?
        scope.where(user: user)
      elsif user.adminish?
        scope.all
      end
    end

  end



end
