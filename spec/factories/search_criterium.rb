FactoryBot.define do
  factory :search_criterium do
    state { "att" }
    city { "ath" }
    gender { "male" }
    age_from { 18 }
    age_to { 99 }
    is_signed_in { true }
  end
end
