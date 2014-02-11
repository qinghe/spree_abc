class DefaultTaxon < SpreeTheme.taxon_class
  cattr_accessor :context_routes
   #(:either, :list,:detail,:cart,:account,:checkout, :thanks,:signup,:login)
  self.context_routes = { ContextEnum.account =>"/account",
    ContextEnum.checkout =>"/checkout",
    ContextEnum.cart =>"/cart",
    ContextEnum.signup =>"/signup",
    ContextEnum.login =>"/login"
    }

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
    raise "unimplement" unless context_routes.key?( context )
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