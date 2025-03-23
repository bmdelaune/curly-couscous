class ForecastsController < ApplicationController
  def new
    @address = Address.new
  end

  def show
    @address = Address.new(address_params)

    @forecast = Forecast.retrieve(@address)
  rescue OpenMateo::GeocodeError, OpenMateo::ForecastError => error
    @error = error.message
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :country, :postal_code)
  end
end
