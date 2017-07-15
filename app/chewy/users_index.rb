class UsersIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      default: {
        tokenizer: 'whitespace'
      }
    }
  }

  define_type User do
    field :username, :email, :deleted_at
    field :is_signed_in, type: :boolean
    field :state, value: ->(user) { user.state }
    field :city, value: ->(user) { user.city }
    field :age, value: ->(user) { user.age }
    field :gender, value: ->(user) { user.gender }
    field :created, type: 'date', include_in_all: false,
      value: ->{ created_at } # value proc for source object context
  end
end
