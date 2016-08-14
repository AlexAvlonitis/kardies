module ApplicationHelper
  def render_country(country)
    CS.get[country.to_sym]
  end

  def render_state(country, state = nil)
    "/ #{CS.get(country.to_sym)[state.to_sym]}" if state
  end

  def render_city(country, state = nil, city = nil)
    "/ #{CS.get(country.to_sym, state.to_sym)[city.to_i]}" if state && city
  end
end
