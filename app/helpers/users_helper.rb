module UsersHelper
  def gender_types
    [
      [(t '.gender_man').to_s, 'male'],
      [(t '.gender_woman').to_s, 'female'],
      [(t '.gender_other').to_s, 'other']
    ]
  end
end
