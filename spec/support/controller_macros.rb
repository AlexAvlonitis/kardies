module ControllerMacros
  def login_user
    let(:token) { double :acceptable? => true, resource_owner_id: @user.id }

    before do
      allow_any_instance_of(UserObserver).to receive(:after_create) { true }
      allow_any_instance_of(UserObserver).to receive(:after_confirmation) { true }

      @user ||= FactoryBot.create(:user)
      allow(controller).to receive(:doorkeeper_token) { token }
    end
  end
end
