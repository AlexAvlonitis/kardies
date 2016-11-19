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

  def display_city_info
    city = GC.get_city_name(user.state, user.city)
    state = GC.get_state_name(user.state)
    if city && state
      city + " " + "(" + state + ")"
    else
      ""
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
      no_post
    else
      h.content_tag(:p, h.content_tag(:em, user.send(data)), class: "dark-gray-text")
    end
  end

  def youtube_url
    if user.youtube_url.nil? || user.youtube_url.blank?
      no_post
    else
      h.content_tag :div, class: "video-container" do
        h.content_tag(:iframe, "", src: "https://www.youtube.com/embed/#{user.youtube_url}", frameborder: 0)
      end
    end
  end

  def profile_picture_link(size = :thumb)
    h.link_to h.user_path(user) do
      h.image_tag user.profile_picture(size)
    end
  end

  private

  def no_post
    h.content_tag(:p, h.content_tag(:em, "#{h.t 'users.show.no_post'}"), class: "aluminium-text")
  end

end
