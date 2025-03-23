class Address
  include ActiveModel::API

  attr_accessor :street, :city, :state, :country, :postal_code

  validates_presence_of :postal_code

  def full_address
    [street, city, [state, postal_code].compact.join(" "), country].compact.join(", ")
  end

  def lat_long
    @latitude, @longitude = OpenMateo.geocode(full_address)
  end
end
