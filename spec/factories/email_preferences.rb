FactoryBot.define do
  factory :email_preference do
    news { false }
    likes { false }
    messages { false }
    user
  end
end
