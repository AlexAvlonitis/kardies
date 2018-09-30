FactoryBot.define do
  factory :about do
    job 'mechanic'
    hobby 'knitting'
    relationship_status 'unknown'
    looking_for 'treasures'
    description 'hello world'
    user
  end
end
