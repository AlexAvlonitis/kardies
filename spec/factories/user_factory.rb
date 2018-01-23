FactoryBot.define do
  factory :user do
    username 'asd'
    email 'asd@asd.com'
    password 'asdasdasd'
    admin false
    user_detail
    confirmed_at DateTime.now
  end
end
