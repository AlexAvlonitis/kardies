FactoryGirl.define do

  factory :user do
    username   { FFaker::Internet.user_name }
    email      { FFaker::Internet.email }
    password   'asdasdasd'
  end

end
