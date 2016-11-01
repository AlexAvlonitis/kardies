class UsersIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      default: {
        tokenizer: 'whitespace'
      }
    }
  }

  define_type User.includes(:user_detail) do
    field :username, :email
    field :deleted_at, type: :boolean
    field :is_signed_in, type: :boolean
    field :state, value: ->(user) { user.user_detail.state }
    field :city, value: ->(user) { user.user_detail.city }
    field :age, value: ->(user) { user.user_detail.age }
    field :gender, value: ->(user) { user.user_detail.gender }
  end
end
