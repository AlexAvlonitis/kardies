FactoryGirl.define do

  factory :user do
    first_name "Alex"
    last_name  "Avlonitis"
    username   "alexxela"
    email      { "#{first_name}.#{last_name}@example.com".downcase }
    password   "asdasdasd"
  end

end
