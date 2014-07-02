
# add a theme into yu-xuan-fu-shi.dalianshops.com

site = Spree::Site.find_by_short_name('yu-xuan-fu-shi')

if site.present?
  SpreeTheme.site_class.current = site
  unless Spree::TemplateTheme.native.select(&:has_native_layout?).present?
    root_section = Spree::Section.find('root2')
    Spree::TemplateTheme.create_plain_template(root_section, site.name)
  end
end  