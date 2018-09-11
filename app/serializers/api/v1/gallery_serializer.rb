module Api
  module V1
    class GallerySerializer < ActiveModel::Serializer
      belongs_to :user
      has_many :pictures
    end
  end
end
