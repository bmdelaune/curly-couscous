class Forecast
  include ActiveModel::API

  attr_accessor :latitude, :longitude,
    :timezone, :timezone_abbreviation, :elevation,
    :temp_units, :wind_units, :cached

  attr_reader :daily, :current

  class << self
    def retrieve(address)
      OpenMateo.forecast(address)
    end
  end

  def cached?
    cached == true
  end

  def daily=(value)
    @daily = value
    
    @daily.each { |day| day.forecast = self }
  end

  def current=(value)
    @current = value

    @current.forecast = self
  end
end
