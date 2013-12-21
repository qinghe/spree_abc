#copy from admin/template_themes_controller#release
@theme = Spree::TemplateTheme.first
template_release = @theme.template_releases.build
template_release.name = "First theme"
template_release.save!
@lg = PageGenerator.releaser( template_release )
@lg.release

SpreeTheme.site_class.current.update_attribute(:template_release_id, template_release.id)
