module Users
  class GetAllUsersQuery
    def self.call(params = {})
      new(params).call
    end

    def initialize(params = {})
      @params = params[:params]
    end

    def call
      ::User.includes(:user_detail).order(created_at: :desc)
    end

    private

    attr_reader :params
  end
end
