module Weathers
  class Erase
    ERASE_KEYS = %i(start end lat lon).freeze

    def initialize(params)
      @params = params
    end

    def call
      if filtered_erase?
        Weather.where(**filtered_keys).delete_all
      else
        Weather.delete_all
      end
    end

    private

    def filtered_erase?
      params.keys.any? { |key| ERASE_KEYS.include?(key) }
    end

    def filtered_keys
      params.slice(*ERASE_KEYS)
    end

    attr_reader :params
  end
end
