FactoryGirl.define do
  factory :user do
    username { Faker::Internet.unique.user_name }
    email { Faker::Internet.unique.email }
    password 'asdasdasd'
    user_detail
  end
end
