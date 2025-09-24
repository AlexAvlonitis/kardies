FactoryBot.define do
  factory :user do
    username { 'asd' }
    email { 'asd@asd.com' }
    password { 'asdasdasd' }
    admin { false }
    confirmed_at { Date.today }
    is_signed_in { true }
    user_detail
    search_criterium
    email_preference
  end
end
