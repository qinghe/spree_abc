SpreeTheme.site_class.where( short_name: 'demo').each_with_index{|site, i|
  if i>0
    SpreeTheme.site_class.with_site(site) do
      site.update_attribute :short_name, "demo#{site.id}"
      site.stores.first.update_attribute :code, site.short_name
    end
  end
}
