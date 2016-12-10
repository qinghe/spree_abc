# This migration comes from spree_multi_site (originally 20150108135747)
class AssociateStoreWithSite < ActiveRecord::Migration
  def change
    add_column :spree_stores, :site_id, :integer, :default=>0
    Spree::Site.all.each{|site|
      unless Spree::Store.unscoped.where( site_id: site.id ).any?
        Spree::Store.unscoped.create!( url: site.domain, name: site.name, code: site.short_name ) do|store|
          store.site_id = site.id
        end
      end
    }
  end


end
