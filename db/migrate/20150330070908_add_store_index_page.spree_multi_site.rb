# This migration comes from spree_multi_site (originally 20150330045999)
class AddStoreIndexPage < ActiveRecord::Migration
  # add feature store disignable 
  def change   
    add_column :spree_stores, :index_page_id, :integer,   :null => false, :default => 0
    add_column :spree_stores, :theme_id,   :integer,   :null => false, :default => 0
    add_column :spree_stores, :template_release_id, :integer,     :null => false, :default => 0

    Spree::Site.all.each{|site|
      site.stores.first.update_attributes( index_page: site.index_page, theme_id: site.theme_id, template_release_id: site.template_release_id )      
    }     
  end
end
