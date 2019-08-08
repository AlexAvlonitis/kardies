# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    current_user.update!(is_signed_in: true) unless current_user.is_signed_in?
  end

  def unsubscribed
    current_user.update!(is_signed_in: false) if current_user.is_signed_in?
  end
end
