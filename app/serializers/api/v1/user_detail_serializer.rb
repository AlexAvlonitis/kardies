module Api
  module V1
    class UserDetailSerializer < ActiveModel::Serializer
      attributes :id,
                 :state,
                 :state_code,
                 :age,
                 :gender,
                 :personality_type,
                 :personality_detail

      def personality_detail
        if object.personality_type
          personality = ::Personality.find_by(code: object.personality_type)
          personality.detail if personality
        else
          nil
        end
      end

      def state
        GC.get_state_name(object.state)
      end

      def state_code
        object.state
      end
    end
  end
end
