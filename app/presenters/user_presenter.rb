class UserPresenter < BasePresenter
  presents :user

  def like_status
    if ! h.current_user.voted_for? user
      h.link_to h.like_user_path(user), method: :put, remote: true, class: 'like-link faa-parent animated-hover', id: "like__#{user.username}" do
        h.fa_icon "heart-o 2x", class: "faa-pulse faa-fast"
      end
    else
      h.link_to h.dislike_user_path(user), method: :put, remote: true, class: 'like-link faa-parent animated-hover', id: "like__#{user.username}" do
        h.fa_icon "heart 2x", class: "faa-pulse faa-fast"
      end
    end
  end

  def online_status
    user.is_signed_in ? h.content_tag(:span, "", class: "online-now") : nil
  end

  def gender_type
    if user.gender == "male"
      h.fa_icon 'mars', class: "gender"
    elsif user.gender == "female"
      h.fa_icon 'venus', class: "gender female"
    else
      h.fa_icon 'transgender', class: "gender other"
    end
  end

  def new_message
    h.link_to h.new_message_path(user), remote: true do
      h.fa_icon "envelope 2x"
    end
  end

  def about_info(data)
    if user.send(data).nil? || user.send(data).empty?
      h.content_tag(:p, h.content_tag(:em, "#{h.t '.no_post'}"), class: "aluminium-text")
    else
      h.content_tag(:p, h.content_tag(:em, user.send(data)), class: "dark-gray-text")
    end
  end

  def profile_picture_link(size = :thumb)
    h.link_to h.user_path(user) do
      h.image_tag user.profile_picture(size)
    end
  end

end
