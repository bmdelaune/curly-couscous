require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET /new" do
    it "renders 200 show page" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("name=\"address[postal_code]\"")
    end
  end

  describe "GET /show" do
    let(:params) { { address: { postal_code: Faker::Address.zip } } }
    let(:latitude) { Faker::Address.latitude }
    let(:longitude) { Faker::Address.longitude }
    let(:forecast) { build(:forecast) }

    before do
      allow(OpenMateo).to receive(:geocode).and_return([latitude, longitude])
      allow(OpenMateo).to receive(:forecast).and_return(forecast)
    end

    it "calls OpenMateo" do
      get forecast_path, params: params

      expect(response).to have_http_status(:ok)
      expect(OpenMateo).to have_received(:forecast)
      expect(response.body).to include(forecast.current.temperature_2m.to_s)
      expect(response.body).to include(forecast.current.apparent_temperature.to_s)
    end
  end
end
