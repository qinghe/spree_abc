# This migration comes from spree_theme (originally 20151017045742)
class AddStoreIsPublic < ActiveRecord::Migration
  # add feature store disignable
  def change
    add_column :spree_stores, :is_public, :boolean, default: false
    SpreeTheme.site_class.all.each{|site|
      site.stores.first.update_attribute :is_public, true
    }
  end
end
