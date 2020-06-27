User.__elasticsearch__.create_index!(force: true)
UserDetail.__elasticsearch__.create_index!(force: true)

Personality.destroy_all

User.destroy_all

nini = User.create(
  username: 'nini',
  email: 'ni_ni9001@hotmail.com',
  password: 'password',
  confirmed_at: Time.now,
  admin: true,
  user_detail_attributes: {
    state: 'att',
    age: 30,
    gender: 'female'
  }
)

100.times do |index|
  u = User.create(
    username: "test_#{index}",
    email: "test_#{index}@test.com",
    password: 'password',
    confirmed_at: Time.now,
    user_detail_attributes: {
      state: 'att',
      age: 30,
      gender: 'male'
    }
  )

  nini.liked_by u
end

personalities = YAML.load_file("config/personalities.yml")['personalities']

personalities.each do |personality|
  Personality.create(
    code: personality.first,
    detail: personality.last
  )
end

User.import
