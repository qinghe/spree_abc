class DefaultTaxon < SpreeTheme.taxon_class

  def self.instance( request_fullpath=nil)
    default_taxon = self.new
    default_taxon.request_fullpath = request_fullpath
    default_taxon
  end
    
  def name
    translated_name = ""
    some_context = current_context
    
    if some_context==ContextEnum.account
      translated_name = case request_fullpath
        when /^\/account/
          "My account"
        when /^\/login/
          "Login as Existing Customer"
        when /^\/checkout\/registration/,/^\/signup/
          "Registration"
        when /^\/password\/recover/
          "Forgot Password?"
        when /^\/password/
          "Forgot Password?"
        else
          "unknown"
      end
    elsif some_context==ContextEnum.checkout
      translated_name = Spree.t(:checkout)
    elsif  some_context==ContextEnum.cart
      translated_name =  Spree.t(:shopping_cart)
    else
      translated_name = "Default #{some_context}"
    end
    translated_name
  end
end