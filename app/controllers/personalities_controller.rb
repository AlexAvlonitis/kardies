class PersonalitiesController < ApplicationController
  def index; end

  def create
    personality_type = Personalities::Test.build(params).execute
    current_user.user_detail.update(personality_type: personality_type)

    render json: { data: personality_type }, status: 201
  rescue StandardError => e
    render json: { error: e }, status: 422
  end
end
