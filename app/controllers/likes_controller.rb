class LikesController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    current_user.vote_notifications.destroy_all
    @likes = current_user.votes_for.order(created_at: :desc).voters
  end

  def like
    user_deleted_check
    add_vote_notification
    if @user.liked_by current_user
      render json: @user, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def unlike
    user_deleted_check
    delete_vote_notification
    if @user.unliked_by current_user
      render json: @user, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
    rescue_error unless @user
  end

  def add_vote_notification
    VoteNotification.create(user_id: @user.id,
                            voted_by_id: current_user.id,
                            vote: true)
  end

  def delete_vote_notification
    vote = VoteNotification.find_by(voted_by_id: current_user.id)
    vote ? vote.destroy! : return
  end

end
