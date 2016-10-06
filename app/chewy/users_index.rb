class UsersIndex < Chewy::Index
  define_type User.includes(:user_detail) do
    field :username, :email
    field :is_signed_in, type: :boolean
    field :state, value: ->(user) { user.user_detail.state }
    field :city, value: ->(user) { user.user_detail.city }
    field :age, value: ->(user) { user.user_detail.age }
  end
end
