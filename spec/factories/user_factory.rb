FactoryGirl.define do

  factory :user do
    first_name { FFaker::Name.name }
    last_name  { FFaker::Name.last_name }
    username   { FFaker::Internet.user_name }
    email      { FFaker::Internet.email }
    password   'asdasdasd'
  end

end
