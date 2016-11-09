class CreateVoteNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_notifications do |t|
      t.references :user, index: true
      t.references :voted_by, index: true
      t.boolean :vote
      t.timestamps
    end
  end
end
