class LikesController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    current_user.vote_notifications.destroy_all
    all_likes_sorted
    suggested_users
  end

  def like
    begin
      if current_user.voted_for? @user
        delete_vote_notification
        @user.unliked_by current_user
        render json: { "heart": 'fa-heart-o' }, status: 201
        return
      end

      if ! current_user.voted_for? @user
        @user.liked_by current_user
        add_vote_notification
        send_notification_email
        render json: { "heart": 'fa-heart' }, status: 201
        return
      end
    rescue
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

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

  def send_notification_email
    HeartsNotificationEmail.new(@user).send
  end

  def suggested_users
    @suggested_users ||= SuggestedUsers.new(current_user).process
  end

  def all_likes_sorted
    @likes ||= current_user.votes_for.limit(20).order(created_at: :desc).voters
  end
end
