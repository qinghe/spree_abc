Spree::Variant.class_eval do

  #include ActionView::Helpers::NumberHelper

  #attr_accessible :option_values

  def to_hash
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    {
      :id    => self.id,
      #:count => self.total_on_hand,
      :in_stock => self.in_stock?,
      :price => self.display_price
      #:price => number_to_currency(actual_price)

    }
  end

end
