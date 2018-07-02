module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      belongs_to :sender

      attributes :body, :created_at
    end
  end
end
