class Sprangular::TaxonomiesController < Sprangular::BaseController
  def index
    
    #@taxonomies = Spree::Taxonomy.order('name').includes(root: :children)
    # get configuration from mobile_theme
    assigned_taxons = @mobile_theme.assigned_resources( Spree::Taxon ).compact
    assigned_taxonomy_ids =  assigned_taxons.map(&:taxonomy_id).uniq
    @taxonomies = Spree::Taxonomy.order('name').includes(root: :children).find( assigned_taxonomy_ids )
  end
end
