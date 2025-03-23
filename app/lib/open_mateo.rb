class OpenMateo
  class ForecastError < StandardError; end

  FORECAST_SETTINGS = {
    current: %w(temperature_2m precipitation relative_humidity_2m apparent_temperature wind_speed_10m wind_gusts_10m),
    daily: %w(temperature_2m_min temperature_2m_max),
    temperature_unit: "fahrenheit",
    wind_speed_unit: "mph",
    precipitation_unit: "inch",
    timezone: "auto",
    models: "gfs_seamless"
  }.freeze

  def self.client
    @client ||= Faraday.new(
        headers: {'Content-Type' => 'application/json'}
    )
  end

  def self.geocode(name)
    parsed_response = Rails.cache.fetch(name, expires_in: 30.minutes) do
      response = client.get("https://geocoding-api.open-meteo.com/v1/search", name:)

      parsed_response = JSON.parse(response.body)
    end.with_indifferent_access

    latitude, longitude = parsed_response.dig("results", 0).slice(:latitude, :longitude).values
  end

  # {"latitude" => 33.001534, "longitude" => -97.217964, "generationtime_ms" => 0.07319450378417969,
  #   "utc_offset_seconds" => -18000, "timezone" => "America/Chicago", "timezone_abbreviation" => "GMT-5",
  #   "elevation" => 193.0,
  #   "current_units" => {"time" => "iso8601", "interval" => "seconds", "temperature_2m" => "°F",
  #     "precipitation" => "inch", "relative_humidity_2m" => "%", "apparent_temperature" => "°F",
  #     "wind_speed_10m" => "mp/h", "wind_gusts_10m" => "mp/h"},
  #   "current" => {"time" => "2025-03-23T13:15", "interval" => 900, "temperature_2m" => 78.3,
  #     "precipitation" => 0.0, "relative_humidity_2m" => 46, "apparent_temperature" => 75.2,
  #     "wind_speed_10m" => 15.8, "wind_gusts_10m" => 18.8},
  #   "daily_units" => {"time" => "iso8601", "temperature_2m_min" => "°F", "temperature_2m_max" => "°F"},
  #   "daily" => {"time" => ["2025-03-23", "2025-03-24", "2025-03-25", "2025-03-26", "2025-03-27", "2025-03-28", "2025-03-29"],
  #     "temperature_2m_min" => [59.7, 47.8, 55.9, 61.1, 65.3, 64.0, 66.0], "temperature_2m_max" => [79.9, 79.7, 86.0, 81.6, 82.2, 70.5, 84.5]}}
  def self.forecast(address)
    raise ForecastError("Postal Code is required for address") unless address.present? && address.postal_code.present?

    cached = true
    parsed_response = Rails.cache.fetch(address.postal_code, expires: 30.minutes) do
      latitude, longitude = address.lat_long
      cached = false
      response = client.get("https://api.open-meteo.com/v1/forecast", latitude:, longitude:, **FORECAST_SETTINGS)

      JSON.parse(response.body)
    end.with_indifferent_access


    parse_forecast(parsed_response, cached)
  end

  private

  def self.parse_forecast(payload, cached)
    forecast = Forecast.new(
        payload.slice(:latitude, :longitude,
        :timezone, :timezone_abbreviation, :elevation,
        :temp_units, :daily, :current, :wind_units)
    ).tap do |f|
      f.temp_units = payload.dig(:current_units, :temperature_2m)
      f.wind_units = payload.dig(:current_units, :wind_speed_10m)
        f.daily = parse_daily_forecast(payload.dig(:daily))
      f.current = parse_current_forecast(payload.dig(:current))
      f.cached = cached
    end
  end

  def self.parse_daily_forecast(payload)
    payload.dig(:time).each_with_index.map do |date, index|
      min = payload.dig(:temperature_2m_min, index)
      max = payload.dig(:temperature_2m_max, index)

      ForecastDay.new(date: Date.iso8601(date).strftime, min:, max:)
    end
  end

  def self.parse_current_forecast(payload)
    ForecastDay.new(date: Date.iso8601(payload.dig(:time)).strftime, **payload.except(:time, :interval))
  end
end
