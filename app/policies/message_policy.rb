class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.all
      end
    end
  end
end
