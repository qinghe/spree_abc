# template support locale
class AddLocaleIntoTemplateTheme < ActiveRecord::Migration
    
  def change
    add_column :spree_template_themes, :locale, :string, :limit=>24
    add_column :spree_template_themes, :home_page_id, :integer
  end

end
