class BlockedUser < ApplicationRecord
  belongs_to :user

  validates :blocked_user_id, presence: true
end
