class DefaultTaxonRoot < DefaultTaxon
  attr_accessor :default_taxon, :taxonomy
  # initialize default_taxon after self initialzed, use the newest request_fullpath
  def default_taxon
    if @default_taxon.nil?
      @default_taxon = DefaultTaxon.instance( self.request_fullpath )
      @default_taxon.root = self # required by inherited_page_context
    end
    @default_taxon
  end

  def children
    taxons = case current_context
      when ContextEnum.login
        [ DefaultTaxon.instance_by_context( ContextEnum.login ),
          DefaultTaxon.instance_by_context( ContextEnum.signup )  ].each{|taxon| taxon.root = self}
      when ContextEnum.account
        [ DefaultTaxon.instance_by_context( ContextEnum.account ),
          DefaultTaxon.instance_by_context( ContextEnum.logout )  ].each{|taxon| taxon.root = self}
      else
        [self.default_taxon]
      end

  end

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
  # menu_item_atom required
  def depth
    0
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
