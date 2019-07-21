FactoryBot.define do
  factory :vote_notification do
    user_id { 1 }
    voted_by_id { 2 }
    vote { true }
  end
end
