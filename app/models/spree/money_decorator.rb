#encoding:utf-8
Spree::Money.class_eval do
  unless method_defined?(:to_html_with_cny_symbol)
    # fix price.to_html =>元 12.00   ¥12.00
    # fix price.to_html =>¥12.00 CNY ¥12.00  
    def to_html_with_cny_symbol(options = { :html => true })
      options.merge! :with_currency => false, :symbol=>true 
      to_html_without_cny_symbol( options )
    end
    alias_method_chain :to_html,:cny_symbol
  end  
end