FactoryBot.define do
  factory :user_detail do
    state { 'att' }
    age { '32' }
    gender { 'male' }

    trait :profile_picture do
      transient do
        profile_picture { file_fixture("images/missing.png") }

        after :build do |user, evaluator|
          user_detail.profile_picture.attach(
            io: evaluator.profile_picture.open,
            filename: evaluator.profile_picture.basename.to_s,
          )
        end
      end
    end
  end
end
