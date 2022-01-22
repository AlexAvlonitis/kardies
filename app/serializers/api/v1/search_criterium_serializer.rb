module Api
  module V1
    class SearchCriteriumSerializer < ActiveModel::Serializer
      belongs_to :user

      attributes :state, :gender, :age_from, :age_to, :is_signed_in
    end
  end
end
