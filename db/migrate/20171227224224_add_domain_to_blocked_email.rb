class AddDomainToBlockedEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :blocked_emails, :domain, :string, after: :email
  end
end
