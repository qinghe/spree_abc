#copy from admin/template_themes_controller#release
@theme = Spree::TemplateTheme.first
@theme.release

SpreeTheme.site_class.current.apply_theme @theme
