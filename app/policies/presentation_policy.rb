class PresentationPolicy < ApplicationPolicy

  def preview?
    show?
  end

  def push?
    user.adminish?
  end

  class Scope < Scope
  
    def resolve
      if user.user?
        scope.where(user: user)
      elsif user.adminish?
        scope.all
      else
        raise "Don't know what to do with this user! #{user.inspect}"
      end
    end

  end



end
