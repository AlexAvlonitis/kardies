module UsersHelper
  def gender_types
    [
      ["#{t '.gender_man'}", "male"],
      ["#{t '.gender_woman'}", "female"],
      ["#{t '.gender_other'}", "other"]
    ]
  end
end
