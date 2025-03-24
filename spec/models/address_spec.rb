require 'rails_helper'

RSpec.describe Address, type: :model do
  subject { build(:address) }

  describe "new" do
    %i(street city state country postal_code).each do |attribute|
      let(:value) { Faker::Alphanumeric.alphanumeric }
      it "allows initializing with #{attribute}" do
        addr = Address.new("#{attribute}": value)
        expect(addr.send(attribute)).to eq(value)
      end
    end
  end

  describe "#full_address" do
    let(:street) { Faker::Address.street_address }
    let(:city) { Faker::Address.city }
    let(:state) { Faker::Address.state_abbr }
    let(:postal_code) { Faker::Address.zip }
    let(:country) { Faker::Address.country }

    subject { build(:address, street:, city:, state:, postal_code:, country:) }

    it "returns the full address" do
      expect(subject.full_address).to eq("#{street}, #{city}, #{state} #{postal_code}, #{country}")
    end
  end

  describe "#lat_long" do
    let(:latitude) { Faker::Address.latitude }
    let(:longitude) { Faker::Address.longitude }

    before do
      allow(OpenMateo).to receive(:geocode).with(subject.full_address).and_return([latitude, longitude])
    end

    it "retrieves from OpenMateo" do
      lat, long = subject.lat_long

      expect(lat).to eq(latitude)
      expect(long).to eq(longitude)
      expect(OpenMateo).to have_received(:geocode).with(subject.full_address)
    end
  end
end
