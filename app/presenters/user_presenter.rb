class UserPresenter < BasePresenter
  presents :user

  def like_status
    if ! h.current_user.voted_for? user
      h.link_to h.like_user_path(user), method: :put, remote: true, class: 'like-link', id: "like__#{user.username}" do
        h.fa_icon "heart-o 2x"
      end
    else
      h.link_to h.dislike_user_path(user), method: :put, remote: true, class: 'like-link', id: "like__#{user.username}" do
        h.fa_icon "heart 2x"
      end
    end
  end

  def online_status
    user.is_signed_in ? h.content_tag(:span, "", class: "online-now") : nil
  end

  def new_message
    h.link_to h.new_message_path(user) do
      h.fa_icon "envelope 2x"
    end
  end

  def profile_picture_link(size = :thumb)
    h.link_to h.user_path(user) do
      h.image_tag user.profile_picture(size)
    end
  end

end
