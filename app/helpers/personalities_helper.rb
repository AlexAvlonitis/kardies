module PersonalitiesHelper
  def personalities_detail(personality_type)
    personality = Personality.find_by(code: personality_type)
    personality.detail if personality
  end
end
