Spree::Admin::TemplateThemesController.class_eval do
  # description - import theme with taxonomy into current site
  #               in this way, it is simpler for user, click 'buy', done.
  def import
    imported_theme = @template_theme.import_with_resource( )
    if  @template_theme.mobile.present?
      imported_mobile_theme = @template_theme.mobile.import_with_resource( )
      imported_mobile_theme.update_attribute(:master_id, imported_theme.id)
    end

    if imported_theme.present?
      if imported_theme.store.template_themes.count == 1
        imported_theme.store.apply_theme imported_theme
      end
      flash[:success] = Spree.t('notice_messages.theme_imported')
    else
      flash[:success] = Spree.t('notice_messages.theme_not_imported')
    end

    respond_to do |format|
      format.html { redirect_to(foreign_admin_template_themes_url) }
    end
  end

end
