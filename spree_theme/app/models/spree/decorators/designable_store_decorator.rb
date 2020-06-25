Spree::Store.class_eval do
  # a template_theme belong to store now.
  # get themplate_themes belongs to designable store, TemplateTheme.foreign
  scope :designable, ->{ where( designable: true )}
  belongs_to :template_theme, :foreign_key=>"theme_id"
  has_many :template_themes
  has_many :template_themes, :dependent=>:destroy
  belongs_to :home_page, :foreign_key=>'index_page_id', :class_name=>'Taxon'

  has_one :logo, class_name: 'Spree::StoreLogo', :as => :viewable,  :dependent => :destroy
  has_one :favicon, class_name: 'Spree::StoreFavicon', :as => :viewable,  :dependent => :destroy

  accepts_nested_attributes_for :logo,:favicon

  # shop's resource should be in this folder
  def self.document_root
    File.join(Rails.root,'public')
  end

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
    self.class.document_root + self.path
  end

  def path
    # here we have to user self.site_id, site.current may not same as self.site
    # ex. current site use a theme of design site to render page
    # Store.id
    File.join( File::SEPARATOR + 'shops', Rails.env, self.site_id.to_s )
  end

  # for feature show template detail
  # access templates of design shop
  def template_accessible?
    code == 'www'
  end

  private
  #override original one
  def ensure_default_exists_and_is_unique
  end

end
