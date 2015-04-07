class PresentationPolicy < ApplicationPolicy

  def push?
    user.adminish?
  end

  def display?
    user.videowall?
  end

  class Scope < Scope
  
    def resolve
      if user.user?
        scope.where(user: user)
      elsif user.adminish? || user.videowall?
        scope.all
      else
        raise "Don't know what to do with this user! #{user.inspect}"
      end
    end

  end



end
