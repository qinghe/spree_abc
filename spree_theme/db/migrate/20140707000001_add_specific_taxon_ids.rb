class AddSpecificTaxonIds < ActiveRecord::Migration
  def change
    #add_column :spree_template_themes, :specific_taxon_ids, :string, :default => ''
    change_column :spree_template_files, :theme_id , :integer, :limit => 2, :null => false, :default => 0
  end

end
