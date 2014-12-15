class RenameSlugToPermalink < ActiveRecord::Migration
  def change
    rename_column :spree_template_texts, :slug , :permalink
  end
end
