# This migration comes from spree_theme (originally 20170228070030)
class AddThemeName < ActiveRecord::Migration
  def change
    add_column :spree_stores, :file_theme_name, :string
  end

end
