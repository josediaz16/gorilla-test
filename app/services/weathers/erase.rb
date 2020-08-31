module Weathers
  class Erase
    ERASE_KEYS = %i(start end lat lon).freeze

    def initialize(params)
      @params = params
    end

    def call
      if params.blank?
        Weather.delete_all
      else
        Weather
          .joins(:location)
          .where(**location_filters)
          .where(date_filter)
          .delete_all
      end
    end

    private

    def filtered_erase?
      params.keys.any? { |key| ERASE_KEYS.include?(key.to_sym) }
    end

    def location_filters
      {
        locations: {
          lat: params[:lat],
          lon: params[:lon]
        }
      }
    end

    def date_filter
      Arel.sql("date BETWEEN '#{params[:start]}' AND '#{params[:end]}'")
    end

    attr_reader :params
  end
end
