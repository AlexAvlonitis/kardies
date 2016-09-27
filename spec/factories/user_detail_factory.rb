FactoryGirl.define do

  factory :user_detail do
    first_name  { FFaker::Name.first_name }
    last_name   { FFaker::Name.last_name }
    city        { FFaker::Address.city }
    age         { FFaker::Time.date }
    gender      'male'
  end

end
