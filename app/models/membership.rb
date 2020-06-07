class Membership < ApplicationRecord
  belongs_to :user

  def expired?
    return false unless subscription_id

    expiry_date_int = expiry_date || 0
    (Time.at(expiry_date_int) < Time.now) ? true : false
  end
end
