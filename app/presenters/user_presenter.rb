class UserPresenter < BasePresenter
  presents :user

  def like_status
    if ! h.current_user.voted_for? user
      h.link_to h.like_user_path(user), method: :put do
        h.fa_icon "heart-o 2x", class: "pull-right"
      end
    else
      h.link_to h.dislike_user_path(user), method: :put do
        h.fa_icon "heart 2x", class: "pull-right"
      end
    end
  end

  def new_message
    h.link_to h.new_user_message_path(user) do
      h.fa_icon "envelope 2x"
    end
  end

  def profile_picture_link(size = :thumb)
    h.link_to h.user_path(user.username) do
      h.image_tag user.profile_picture(size),
      class: "card-img-top"
    end
  end

end
