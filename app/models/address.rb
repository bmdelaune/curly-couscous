class Address
  include ActiveModel::API

  attr_accessor :street, :city, :state, :country, :postal_code

  validates_presence_of :postal_code
end
