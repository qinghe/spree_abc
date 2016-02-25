class AddFileAlt < ActiveRecord::Migration
  def change
    add_column :spree_template_files, :alt, :string
  end

end
