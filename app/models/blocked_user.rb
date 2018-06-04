class BlockedUser < ApplicationRecord
  belongs_to :user

  validates_presence_of :blocked_user_id
end
