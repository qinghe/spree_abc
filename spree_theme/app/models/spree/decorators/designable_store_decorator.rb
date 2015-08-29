Spree::Store.class_eval do
  # a template_theme belong to store now.
  # get themplate_themes belongs to designable store, TemplateTheme.foreign
  scope :designable, ->{ where( designable: true )}
  belongs_to :template_theme, :foreign_key=>"theme_id"
  has_many :template_themes
  has_many :template_themes, :dependent=>:destroy
  belongs_to :home_page, :foreign_key=>'index_page_id', :class_name=>'Taxon'

  def layout
    self.template_theme.present? ? self.template_theme.layout_path : nil
  end

  # apply theme to site
  # params - theme_or_release, TemplateTheme or TemplateRelease
  def apply_theme( theme )
    self.theme_id= theme.id
    save!
  end

  def document_path
    SpreeTheme.site_class.current.document_path
  end

  def path
    SpreeTheme.site_class.current.path
  end
end
