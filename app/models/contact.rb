class Contact < ApplicationRecord
  validates :name, :email, :subject, :description, presence: true
end
