#copy from admin/template_themes_controller#release
@theme = Spree::TemplateTheme.first
@theme.release

Spree::Store.current.apply_theme @theme
