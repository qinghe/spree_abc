# This migration comes from spree_multi_site (originally 20150108135747)
class AssociateStoreWithSite < ActiveRecord::Migration
  def change
    add_column :spree_stores, :site_id, :integer, :default=>0
    Spree::Site.all.each{|site|
      if site.stores.blank?
        site.stores.create!( url: site.domain, name: site.name, code: site.short_name )
      end
    }
  end


end
