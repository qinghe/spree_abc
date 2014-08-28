class DefaultTaxonRoot < DefaultTaxon
  attr_accessor :default_taxon, :taxonomy
  # initialize default_taxon after self initialzed, use the newest request_fullpath
  def default_taxon
    if @default_taxon.nil?    
      @default_taxon = DefaultTaxon.instance( self.request_fullpath )
      @default_taxon.root = self
    end
    @default_taxon
  end
    
  def children
    [self.default_taxon]
  end
  
  #def descendants
  #  [self.default_taxon]    
  #end
  
  def taxonomy
    @taxonomy ||= DefaultTaxonomy.new( self )
  end
  # called by template.menu
  def self_and_descendants
    [self, children].flatten
  end

  def root?
    true
  end
  
  def root
    self
  end
  
end

class DefaultTaxonomy 
  attr_accessor :name, :default_taxon_root
  def initialize( default_taxon)
    self.default_taxon_root = default_taxon
  end
  
  def name
    Spree.t "default_page.taxonomy"
  end
end