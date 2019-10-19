module Api
  module V1
    class PictureSerializer < ActiveModel::Serializer
      attributes :id, :picture, :picture_medium
    end
  end
end
