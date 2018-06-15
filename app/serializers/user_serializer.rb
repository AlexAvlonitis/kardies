class UserSerializer < ActiveModel::Serializer
  has_one :user_detail

  attributes :username, :profile_picture, :profile_picture_medium
end
