class ForecastsController < ApplicationController
  def new
    @address = Address.new
  end

  def show
    @address = Address.new(address_params)

    @forecast = "here's a forecast!"
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :country, :postal_code)
  end
end
