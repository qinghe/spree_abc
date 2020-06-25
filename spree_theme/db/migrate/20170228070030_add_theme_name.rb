class AddThemeName < ActiveRecord::Migration
  def change
    add_column :spree_stores, :file_theme_name, :string
  end

end
