class ForecastDayPresenter
  delegate :temp_units, :wind_units, :precipitation, to: :@forecast

  def initialize(forecast_day)
    @forecast = forecast_day
  end

  def day
    @forecast.date.strftime("%a, %b %-d")
  end

  def min
    "#{@forecast.min} #{temp_units}"
  end

  def max
    "#{@forecast.max} #{temp_units}"
  end

  def temp
    "#{@forecast.temperature_2m} #{temp_units}"
  end

  def feels_like
    "#{@forecast.apparent_temperature} #{temp_units}"
  end

  def wind_speed
    "#{@forecast.wind_speed_10m} #{wind_units}"
  end

  def cache_note
    @forecast.cached? ? "Data is pulled from cache. Refreshed every 30 minutes." : ""
  end
end
