class PersonalitiesController < ApplicationController
  def index; end

  def create
    results = Personalities::Test.build(params).execute
    current_user.user_detail
                .update(
                  personalities: results,
                  personalities_detail: personalities_detail(results)
                )

    render json: { data: results }, status: 201
  rescue StandardError => e
    render json: { error: e }, status: 422
  end

  private

  def personalities_detail(code)
    PERSONALITIES[code]
  end
end
