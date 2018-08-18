class About < ApplicationRecord
  belongs_to :user

  validates :description, length: {
    maximum: 1000,
    too_long: "1000 #{I18n.t 'abouts.edit.character_length'}"
  }
end
