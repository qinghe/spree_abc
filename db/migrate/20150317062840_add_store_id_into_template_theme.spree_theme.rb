# This migration comes from spree_theme (originally 20150317000001)
class AddStoreIdIntoTemplateTheme < ActiveRecord::Migration
    
  def self.up
    add_column :spree_template_themes, :store_id, :integer
    Spree::TemplateTheme.all.each{|theme|
      theme.update_attribute :store_id, Spree::Store.unscoped.where(site_id: theme.site_id).first.id
    }
  end
  
  def self.down
    remove_column :spree_template_themes, :store_id
  end
end
