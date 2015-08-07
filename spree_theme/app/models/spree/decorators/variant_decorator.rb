Spree::Variant.class_eval do

  #include ActionView::Helpers::NumberHelper

  #attr_accessible :option_values

  def to_hash
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    {
      :id    => self.id,
      :count => self.total_on_hand,
      :price => self.display_price
    }
  end

end
