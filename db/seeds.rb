Personality.destroy_all

Chewy.strategy(:atomic) do
  User.destroy_all
end

Chewy.strategy(:atomic) do
  User.create(
    username: 'nini',
    email: 'ni_ni9001@hotmail.com',
    password: 'password',
    confirmed_at: Time.now,
    user_detail_attributes: {
      state: 'att',
      city: 'athina-ATT',
      age: 30,
      gender: 'female'
    }
  )

  3.times do |index|
    User.create(
      username: "test_#{index}",
      email: "test_#{index}@test.com",
      password: 'password',
      confirmed_at: Time.now,
      user_detail_attributes: {
        state: 'att',
        city: 'athina-ATT',
        age: 30,
        gender: 'male'
      }
    )
  end
end

PERSONALITIES.each do |personality|
  Personality.create(
    code: personality.first,
    detail: personality.last
  )
end
