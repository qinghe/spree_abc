# This migration comes from spree_theme (originally 20160225070030)
class AddFileAlt < ActiveRecord::Migration
  def change
    add_column :spree_template_files, :alt, :string
  end

end
