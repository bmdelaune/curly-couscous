FactoryBot.define do
  factory :forecast_day do
    date { Faker::Date.between(from: Date.today, to: 10.days.from_now) }
    min { Faker::Number.between(from: -20, to: 100) }
    max { Faker::Number.between(from: min, to: 120) }
    temperature_2m { Faker::Number.between(from: -20, to: 100) }
    precipitation { Faker::Number.between(from: -20, to: 100) }
    relative_humidity_2m { Faker::Number.between(from: -20, to: 100) }
    apparent_temperature { Faker::Number.between(from: -40, to: 130) }
    wind_gusts_10m { Faker::Number.between(from: 0, to: 80) }
    wind_speed_10m { Faker::Number.between(from: 0, to: 60) }
  end
end
