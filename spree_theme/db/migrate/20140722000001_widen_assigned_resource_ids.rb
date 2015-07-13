class WidenAssignedResourceIds < ActiveRecord::Migration
  def change
    #add_column :spree_template_themes, :specific_taxon_ids, :string, :default => ''
    change_column :spree_template_themes, :assigned_resource_ids , :string, :limit => 1024, :null => false, :default => ''
  end
end
