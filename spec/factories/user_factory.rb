FactoryBot.define do
  factory :user do
    username { 'asd' }
    email { 'asd@asd.com' }
    password { 'asdasdasd' }
    admin { false }
    confirmed_at { DateTime.now }
    user_detail
    membership
  end
end
