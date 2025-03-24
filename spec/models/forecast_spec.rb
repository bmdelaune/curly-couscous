require 'rails_helper'

RSpec.describe Forecast, type: :model do
  subject { build(:forecast) }

  describe ".retrieve" do
    let(:address) { build(:address) }
    before do
      allow(OpenMateo).to receive(:forecast).with(address).and_return(subject)
    end

    it "calls OpenMateo" do
      expect(Forecast.retrieve(address)).to eq(subject)
      expect(OpenMateo).to have_received(:forecast).with(address)
    end
  end

  describe "new" do
    %i(latitude longitude timezone elevation temp_units wind_units cached).each do |attribute|
      let(:value) { Faker::Alphanumeric.alphanumeric }

      it "allows initializing with #{attribute}" do
        cast = Forecast.new("#{attribute}": value)
        expect(cast.send(attribute)).to eq(value)
      end
    end
  end

  describe "#cached?" do
    subject { build(:forecast, cached:).cached? }

    context "when cached is true" do
      let(:cached) { true }

      it "returns true" do
        expect(subject).to be_truthy
      end
    end

    context "when cached is false" do
      let(:cached) { false }

      it "returns true" do
        expect(subject).to be_falsey
      end
    end
  end

  describe "#daily=" do
    subject { build(:forecast) }
    let(:daily_forecast) { build_list(:forecast_day, 7)}

    it "sets itself as the forecast" do
      subject.daily = daily_forecast

      daily_forecast.each do |day_cast|
        expect(subject.daily).to include(day_cast)
        expect(day_cast.forecast).to eq(subject)
      end
    end
  end

  describe "#current=" do
    subject { build(:forecast) }
    let(:current) { build(:forecast_day)}

    it "sets itself as the forecast" do
      subject.current = current

      expect(subject.current).to eq(current)
      expect(current.forecast).to eq(subject)
    end
  end
end
