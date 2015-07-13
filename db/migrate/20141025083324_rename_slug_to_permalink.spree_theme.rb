# This migration comes from spree_theme (originally 20141022000001)
class RenameSlugToPermalink < ActiveRecord::Migration
  def change
    rename_column :spree_template_texts, :slug , :permalink
  end
end
