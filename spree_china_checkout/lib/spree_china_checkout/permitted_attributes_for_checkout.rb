module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_CHECKOUT=[:city_attributes]
    mattr_reader *ATTRIBUTES_FOR_CHECKOUT

    @@city_attributes = [:name, :abbr]
    @@address_attributes += [:city_name, :city_id]
  end
end