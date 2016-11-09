class UsersController < ApplicationController

  before_action :set_user, except: [:index]

  def index
    if search_params.present?
      @users = User.search(search_params).page params[:page]
    else
      @users = User.all_except(current_user).not_blocked.page params[:page]
    end
  end

  def show
    user_deleted_check
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

  def search_params
    set_age_range
    all_params = {}
    all_params[:state] = params[:state] if params[:state] && !params[:state].blank?
    all_params[:city] = params[:city] if params[:city] && !params[:city].blank?
    all_params[:is_signed_in] = params[:is_signed_in] if params[:is_signed_in] && !params[:is_signed_in].blank?
    all_params[:username] = params[:username] if params[:username] && !params[:username].blank?
    all_params[:age] = set_age_range if set_age_range
    all_params[:gender] = params[:gender] if params[:gender] && !params[:gender].blank?
    all_params
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

  def set_age_range
    if params[:age_from] && !params[:age_from].blank? && params[:age_to] && !params[:age_to].blank?
      [params[:age_from], params[:age_to]]
    else
      nil
    end
  end

  def user_deleted_check
    rescue_error if ! @user.deleted_at.nil?
  end

  def set_user
    @user = User.find_by_username(params[:username])
    rescue_error unless @user
  end

  def rescue_error
    flash[:alert] = 'The user you were looking for could not be found'
    redirect_to users_path
  end
end
