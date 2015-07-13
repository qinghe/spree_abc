#copy from spree/core/model/spree/classification
module Spree
  class PostClassification < ActiveRecord::Base
    self.table_name = 'spree_posts_taxons'
    belongs_to :post, class_name: "Spree::Post"
    belongs_to :taxon, class_name: "Spree::Taxon"

    # For #3494
    validates_uniqueness_of :taxon_id, :scope => :post_id, :message => :already_linked
  end
end
