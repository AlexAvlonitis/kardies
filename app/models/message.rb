class Message < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  def sender
    User.find(self.posted_by).full_name unless posted_by.blank?
  end

  def receiver
    User.find(self.user_id).full_name unless user_id.blank?
  end

end
