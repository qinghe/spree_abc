class DefaultTaxon < SpreeTheme.taxon_class

  class DefaultTaxonRoot < DefaultTaxon
    attr_accessor :default_taxon
    def initialize( default_taxon)
      self.default_taxon = default_taxon
    end
    
    def children
      [self.default_taxon]
    end
    
    #TODO taxonomy
  end
  
  # * params
  #   * context - one of ContextEnum member
  def self.instance_by_context( context )
    unless context_routes.key?( context )
      raise "unimplement for context:#{context}" 
    end
    request_fullpath = context_routes[context]  
    instance( request_fullpath )
  end
    
  def self.instance( request_fullpath=nil)
    default_taxon = self.new
    default_taxon.request_fullpath = request_fullpath
    default_taxon
  end
  
  begin "get default taxon tree,  default menu tree using by theme"
    def root
      DefaultTaxonRoot.new( self )
    end
    
    def self_and_descendants
      [root, self]
    end
    # menu section would call default_taxon.children
    def children
      []
    end
  end
     
  def name
    translated_name = ""
    some_context = current_context
    
    if some_context==ContextEnum.account
      translated_name = case request_fullpath
        when /^\/account/
          Spree.t("default_page.account")
        when /^\/login/
          Spree.t("default_page.login")
        when /^\/checkout\/registration/,/^\/signup/
          Spree.t("default_page.signup")
        when /^\/password\/recover/
          Spree.t("default_page.password")
        when /^\/password/
          Spree.t("default_page.password")
        else
          "Unknown"
      end
    elsif some_context==ContextEnum.checkout
      translated_name = Spree.t(:checkout)
    elsif  some_context==ContextEnum.cart
      translated_name =  Spree.t(:shopping_cart)
    else
      translated_name = Spree.t("default_page.#{some_context}")
    end
    translated_name
  end
end
