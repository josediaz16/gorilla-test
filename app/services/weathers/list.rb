require 'dry/monads'

module Weathers
  class List
    include Dry::Monads[:result]

    def initialize(params)
      @params = params
    end

    def call
      filter
        .fmap { |weathers| serialize(weathers) }
    end

    private

    def filter
      if filtering_by_location?
        filter_by_location
      else
        weathers = Weather
          .where(weather_filters)
          .order(id: :asc)

        Success(weathers)
      end
    end

    def serialize(weathers)
      weathers.map do |weather|
        temperature = JSON.parse(weather["temperature"]).map(&:to_f)

        weather
          .as_json(except: [:location_id], include: { location: { except: [:id] } })
          .merge({ "temperature" => temperature })
      end
    end

    def filtering_by_location?
      params.key?(:lat) || params.key?(:lon)
    end

    def filter_by_location
      weathers = Weather
        .joins(:location)
        .where(locations: {lat: params[:lat], lon: params[:lon]})
        .where(weather_filters)
        .order(id: :asc)

      if weathers.any?
        Success(weathers)
      else
        Failure({ location: 'The location does not exist' })
      end
    end

    def weather_filters
      params.key?(:date) ? Arel.sql("weathers.date = '#{params[:date]}'") : "1=1"
    end

    attr_reader :params
  end
end
