class Report < ApplicationRecord
  belongs_to :user

  def reporter
    User.find_by(id: reporter_id)
  end
end
