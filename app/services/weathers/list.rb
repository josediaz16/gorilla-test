require 'dry/monads'

module Weathers
  class List
    include Dry::Monads[:result]

    def initialize(params)
      @params = params
    end

    def call
      if filtering_by_location?
        filter_by_location
      elsif params.present?
        filter_only_by_date
      else
        Success(basic_query)
      end
    end

    private

    def filtering_by_location?
      params.key?(:lat) || params.key?(:lon)
    end

    def filter_only_by_date
      weathers = basic_query

      if weathers.any?
        Success(weathers)
      else
        Failure({ date: 'Nothing found on that date' })
      end

    end

    def filter_by_location
      weathers = basic_query
        .joins(:location)
        .where(locations: {lat: params[:lat], lon: params[:lon]})

      if weathers.any?
        Success(weathers)
      else
        Failure({ location: 'The location does not exist' })
      end
    end

    def basic_query
      Weather
        .where(weather_filters)
        .order(id: :asc)
    end

    def weather_filters
      params.key?(:date) ? Arel.sql("weathers.date = '#{params[:date]}'") : "1=1"
    end

    attr_reader :params
  end
end
