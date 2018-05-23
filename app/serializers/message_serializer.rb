class MessageSerializer < ActiveModel::Serializer
  belongs_to :sender

  attributes :body, :created_at
end
