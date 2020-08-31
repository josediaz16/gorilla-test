class LocationSerializer < ActiveModel::Serializer
  attributes :lat, :lon, :city, :state

  def lat
    object.lat.to_f
  end

  def lon
    object.lon.to_f
  end
end
