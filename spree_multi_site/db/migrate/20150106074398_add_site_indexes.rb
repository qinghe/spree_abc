# This migration comes from spree (originally 20140410141842)
class AddSiteIndexes < ActiveRecord::Migration
  def change
    add_index :spree_site, :short_name    
    add_index :spree_site, :domain
  end
end
