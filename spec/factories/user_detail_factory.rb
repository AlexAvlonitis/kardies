FactoryGirl.define do

  factory :user_detail do
    state       'att'
    city        { FFaker::Address.city }
    age         { FFaker::Time.date }
    gender      'male'
  end

end
