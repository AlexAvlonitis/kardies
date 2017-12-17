class BlockedEmail < ApplicationRecord
  def self.email_list
    if ActiveRecord::Base.connection.table_exists? 'blocked_emails'
      all.map(&:email)
    else
      []
    end
  end
end
