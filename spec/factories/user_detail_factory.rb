FactoryGirl.define do

  factory :user_detail do
    state       'att'
    city        { FFaker::Address.city }
    age         34
    gender      'male'
  end

end
