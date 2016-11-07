class Contact < ApplicationRecord
  validates_presence_of :name, :email, :subject, :description
end
