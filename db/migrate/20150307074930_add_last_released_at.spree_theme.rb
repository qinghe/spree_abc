# This migration comes from spree_theme (originally 20150303000001)
class AddLastReleasedAt < ActiveRecord::Migration
    
  def change
    # get section by usage 'dialog', 'image', 'container'
    add_column :spree_sections, :usage, :string, :limit=>24
    add_column :spree_template_themes, :last_released_at, :datetime
    add_column :spree_template_themes, :last_changed_at, :datetime
  end

end
