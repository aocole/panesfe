class SlidePolicy < ApplicationPolicy

  class Scope < Scope
  
    def resolve
      if user.user?
        scope.includes(:slideshow).where(presentations: {user_id: user})
      elsif user.adminish?
        scope.all
      end
    end

  end



end
