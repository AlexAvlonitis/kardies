FactoryBot.define do
  factory :user_detail do
    state       'att'
    age         '32'
    gender      'male'
    profile_picture File.new("#{Rails.root}/spec/support/fixtures/images/missing.png")
  end
end
