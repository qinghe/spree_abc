class AddThemeIdToPageLayout < ActiveRecord::Migration
  def change
    # use template_theme_id as scope, instead of root_id
    add_column :spree_page_layouts, :template_theme_id, :integer,:null => false, :default=>0
    add_column :spree_page_layouts, :copy_from_id, :integer,:null => false, :default=>0
    add_column :spree_template_themes, :copy_from_id, :integer,:null => false, :default=>0

    Spree::TemplateTheme.all.each{|theme|
      page_layout = Spree::PageLayout.where( id: theme.page_layout_root_id ).first
      # original page_layout is missing
      if page_layout.present?
        if page_layout.site_id == theme.site_id
          # do not use page_layotu.self_and_descendants,  scope is changed to template_theme_id now.
          Spree::PageLayout.where( root_id: theme.page_layout_root_id).update_all(template_theme_id: theme.id)
        else
          original_template_theme = Spree::TemplateTheme.where( page_layout_root_id: theme.page_layout_root_id).first
          theme.update_attribute(:copy_from_id, original_template_theme.id )
        end
      else
        #fix missing page_layout_root_id, theme refer to deleted page_layout_id=1
        theme.update_attribute(:page_layout_root_id, Spree::TemplateTheme.first.page_layout_root_id )
        theme.update_attribute(:copy_from_id, Spree::TemplateTheme.first.id )
      end
    }
  end

end
