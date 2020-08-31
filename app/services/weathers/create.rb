require 'dry/monads'

module Weathers
  class Create
    include Dry::Monads[:result]

    # Dry monads helps on business logic by using railway oriented programming.
    def call(input)
      validate_input(input)
        .fmap { |input| find_or_create_location(input) }
        .bind { |input_with_location| create_weather_entry(input_with_location) }
    end

    private

    def validate_input(input)
      check_if_already_exists(input)
    end

    def find_or_create_location(input)
      location_values = input
        .fetch(:location, {})
        .slice(:lat, :lon, :city, :state)

      location = Location.find_or_create_by(**location_values)
      input.merge({ location_id: location.id }) 
    end

    def create_weather_entry(input)
      weather_values = input.slice(:id, :date, :temperature, :location_id)

      weather = Weather.new(**weather_values)

      if weather.save
        Success(weather)
      else
        Failure(weather.errors.messages)
      end
    end

    def check_if_already_exists(input)
      if Weather.where(id: input[:id]).any?
        Failure({ id: 'The entry already exists' })
      else
        Success(input)
      end
    end
  end
end
