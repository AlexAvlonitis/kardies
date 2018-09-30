class SearchCriterium < ApplicationRecord
  belongs_to :user

  def self.normalize_params(obj)
    obj.state = nil if obj.state.blank?
    obj.gender = nil if obj.gender.blank?
    obj.is_signed_in = nil if obj.is_signed_in == false
    obj
  end
end
