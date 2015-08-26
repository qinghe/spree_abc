Spree::Site.class_eval do
  include SpreeTheme::SiteHelper
end

Spree::TemplateTheme.class_eval do
  belongs_to :site
  # no need default, want to get foreign template.

  def importer
    Spree::TemplateThemeImporter.new( self )
  end

end
