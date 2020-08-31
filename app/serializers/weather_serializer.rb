class WeatherSerializer < ActiveModel::Serializer
  attributes :id, :date, :temperature

  def temperature
    JSON.parse(object.temperature).map(&:to_f)
  end

  belongs_to :location
end
