class Message < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  def sent_by
    posted_by = self.posted_by
    User.find(posted_by).full_name unless posted_by == 0 || posted_by.nil?
  end

  private
end
