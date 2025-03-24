FactoryBot.define do
  factory :forecast do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    timezone { Faker::Address.time_zone }
    elevation { Faker::Number.number(digits: 4) }
    temp_units { "°#{%w(F C).sample}" }
    wind_units { %w(kmph mph).sample }
    cached { [true, false].sample }

    daily { build_list(:forecast_day, 7) }
    current { build(:forecast_day, date: Date.today) }
  end
end
