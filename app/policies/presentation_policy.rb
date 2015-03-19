class PresentationPolicy < ApplicationPolicy

  def show?
    record.user == user
  end


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
