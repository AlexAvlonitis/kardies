class UserDetailSerializer < ActiveModel::Serializer
  attributes :city, :state, :age

  def city
    GC.get_city_name(object.state, object.city)
  end

  def state
    GC.get_state_name(object.state)
  end
end