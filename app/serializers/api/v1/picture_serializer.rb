module Api
  module V1
    class PictureSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :id, :picture, :picture_medium

      def picture
        return unless object&.picture&.attached?

        rails_blob_url(object.picture, only_path: true)
      end

      def picture_medium
        return unless object&.picture&.attached?

        rails_representation_url(object.picture_medium, only_path: true)
      end
    end
  end
end
