class About < ApplicationRecord
  belongs_to :user
  after_update :flush_job_cache, :flush_hobby_cache,
               :flush_relationship_status_cache, :flush_looking_for_cache,
               :flush_description_cache

  validates :description, length: { maximum: 1000,
    too_long: "%{count} #{I18n.t 'abouts.edit.character_length'}" }

  private

  def flush_job_cache
    Rails.cache.delete([:about, id, :job]) if job_changed?
  end

  def flush_hobby_cache
    Rails.cache.delete([:about, id, :hobby]) if hobby_changed?
  end

  def flush_relationship_status_cache
    Rails.cache.delete([:about, id, :relationship_status]) if relationship_status_changed?
  end

  def flush_looking_for_cache
    Rails.cache.delete([:about, id, :looking_for]) if looking_for_changed?
  end

  def flush_description_cache
    Rails.cache.delete([:about, id, :description]) if description_changed?
  end
end
