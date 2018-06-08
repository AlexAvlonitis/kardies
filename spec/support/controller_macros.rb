module ControllerMacros
  def login_user
    before(:each) do
      allow_any_instance_of(User).to receive(:auto_like) { true }
      allow_any_instance_of(User).to receive(:send_welcome_mail) { true }

      user = FactoryBot.create(:user)

      sign_in user
    end
  end
end
