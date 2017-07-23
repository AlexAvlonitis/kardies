# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.

class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    Chewy.strategy(:atomic) do
      current_user.update!(is_signed_in: true) unless current_user.is_signed_in?
    end
  end

  def unsubscribed
    Chewy.strategy(:atomic) do
      current_user.update!(is_signed_in: false) if current_user.is_signed_in?
    end
  end
end
