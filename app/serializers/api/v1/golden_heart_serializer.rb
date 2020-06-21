require 'action_view'

module Api
  module V1
    class GoldenHeartSerializer < ActiveModel::Serializer
      include ActionView::Helpers::DateHelper
      belongs_to :hearter

      attributes :received_date

      def received_date
        distance_of_time_in_words(object.updated_at, Time.now)
      end
    end
  end
end
