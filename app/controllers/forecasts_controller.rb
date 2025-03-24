class ForecastsController < ApplicationController
  def new
    @address = Address.new
  end

  def show
    @address = Address.new(address_params)

    unless @address.valid?
      @error = @address.errors.full_messages.join("\n")
    end

    @forecast = Forecast.retrieve(@address) unless @error.present?
  rescue OpenMateo::GeocodeError, OpenMateo::ForecastError => error
    @error = error.message
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :country, :postal_code)
  end
end
