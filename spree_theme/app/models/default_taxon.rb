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
    case current_context       
      when ContextEnum.checkout
        Spree.t(:checkout)
      when ContextEnum.cart
        Spree.t(:shopping_cart)
      else
        Spree.t("default_page.#{current_context}")
    end    
  end
end
