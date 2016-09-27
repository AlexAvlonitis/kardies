FactoryGirl.define do

  factory :user do
    username   { FFaker::Internet.user_name }
    email      { FFaker::Internet.email }
    password   'asdasdasd'
    after(:create) do |user|
      user.user_detail ||= FactoryGirl.create(:user_detail, user: user)
    end
  end

end
