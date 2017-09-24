class LikesController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    current_user.vote_notifications.destroy_all
    @likes = current_user.votes_for.order(created_at: :desc).voters
    suggested_users
  end

  def like
    user_deleted_check
    if @user.liked_by current_user
      render json: @user, status: 201
      add_vote_notification
      HeartsNotificationEmail.new(@user).send
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

  attr_reader :add_vote_notification, :suggested_users

  def add_vote_notification
    @add_vote_notification ||= AddVoteNotification.new(@user, current_user).add
  end

  def set_user
    @user = User.find_by(username: params[:username])
    rescue_error unless @user
  end

  def delete_vote_notification
    vote = VoteNotification.find_by(voted_by_id: current_user.id)
    vote ? vote.destroy! : return
  end

  def suggested_users
    @suggested_users ||= SuggestedUsers.new(current_user).process
  end
end
