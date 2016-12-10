Spree::Site.where( short_name: 'demo').each_with_index{|site, i|
  if i>0
    Spree::Site.with_site(site) do
      site.update_attribute :short_name, "demo#{site.id}"
      site.stores.first.update_attribute :code, site.short_name
    end
  end
}
