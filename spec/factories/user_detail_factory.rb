FactoryBot.define do
  factory :user_detail do
    state { 'att' }
    age { '32' }
    gender { 'male' }

    trait :profile_picture do
      transient do
        profile_picture do
          File.open('spec/fixtures/files/missing.png')
        end

        after :build do |user_detail, evaluator|
          user_detail.profile_picture.attach(
            io: evaluator.profile_picture,
            filename: 'test_image'
          )
        end
      end
    end
  end
end
