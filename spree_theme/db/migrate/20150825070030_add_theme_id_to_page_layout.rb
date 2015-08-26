class AddThemeIdToPageLayout < ActiveRecord::Migration
  def change
    # use template_theme_id as scope, instead of root_id
    add_column :spree_page_layouts, :template_theme_id, :integer,:null => false, :default=>0
    add_column :spree_page_layouts, :copy_from_id, :integer,:null => false, :default=>0
    add_column :spree_template_themes, :copy_from_id, :integer,:null => false, :default=>0

    Spree::TemplateTheme.all.each{|theme|
      if theme.has_native_layout?
        if theme.page_layout.present?
          theme.page_layout.self_and_descendants.update_all(template_theme_id: theme.id)
        else
          theme.update_attribute(:page_layout_root_id, Spree::TemplateTheme.first.page_layout_root_id )
        end
      else
        theme.update_attribute(:copy_from_id, theme.original_template_theme.id )
      end
    }
  end

end
