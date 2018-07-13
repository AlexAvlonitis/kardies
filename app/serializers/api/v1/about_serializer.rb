module Api
  module V1
    class AboutSerializer < ActiveModel::Serializer
      belongs_to :user

      attributes :job, :hobby, :relationship_status, :looking_for, :description
    end
  end
end
