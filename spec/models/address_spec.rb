require 'rails_helper'

RSpec.describe Address, type: :model do

  describe ".postal_code" do

    it "allows storing a postal code" do
      addr = Address.new(postal_code: "76666")
      expect(addr.postal_code).to eq("76666")
    end
  end

end
