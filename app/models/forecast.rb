class Forecast
  include ActiveModel::API

  attr_accessor :latitude, :longitude,
    :timezone, :timezone_abbreviation, :elevation,
    :temp_units, :daily, :current, :wind_units, :cached

  class << self
    def retrieve(address)
      OpenMateo.forecast(address)
    end
  end
end
