module ControllerMacros
  def login_user
    let(:token) { double :acceptable? => true, resource_owner_id: @user.id }

    before do
      @user ||= FactoryBot.create(:user)
      allow(controller).to receive(:doorkeeper_token) { token }
    end
  end
end
