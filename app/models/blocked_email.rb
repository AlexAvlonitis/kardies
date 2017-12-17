class BlockedEmail < ApplicationRecord
  def self.email_list
    all.map(&:email)
  end
end
