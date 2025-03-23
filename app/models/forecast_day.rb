class ForecastDay
  include ActiveModel::API

  attr_accessor :date, :min, :max,
    :temperature_2m, :precipitation, :relative_humidity_2m,
    :apparent_temperature, :wind_gusts_10m, :wind_speed_10m
end
