module Api
  module V1
    class EmailPreferenceSerializer < ActiveModel::Serializer
      belongs_to :user

      attributes :likes, :messages, :news
    end
  end
end
