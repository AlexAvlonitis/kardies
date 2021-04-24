require 'action_view'

module Api
  module V1
    class NewsSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper
      attributes :meta, :type, :created_at

      def created_at
        distance_of_time_in_words(object.created_at, Time.now)
      end
    end
  end
end
