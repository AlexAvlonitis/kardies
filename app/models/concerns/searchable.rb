module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :id, type: :long
      indexes :username, type: :string
      indexes :email, type: :string
      indexes :is_signed_in, type: :boolean

      indexes :user_detail, type: :nested do
        indexes :id, type: :long
        indexes :first_name, type: :string
        indexes :last_name, type: :string
        indexes :state, type: :string
        indexes :city, type: :string
        indexes :age, type: :date
      end
    end

    def self.search(query)
      __elasticsearch__.search(
        {
          query: {
            match_all: {}
          }
        }
      )
    end
  end

end
