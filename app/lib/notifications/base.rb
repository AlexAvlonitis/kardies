module Notifications
  class Base
    def initialize(user)
      @user = user
    end

    private

    attr_reader :user
  end
end
