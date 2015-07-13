#encoding: utf-8
Spree::Site.current = Spree::Site.first
taxonomies = [
  { :name => "MainMenu" },
#  { :name => "Unlogged" },
#  { :name => "Logged" }
]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.create!(taxonomy_attrs)
end

main_menu = Spree::Taxonomy.find_by_name!("MainMenu")
#unlogged = Spree::Taxonomy.find_by_name!("Unlogged")
#logged = Spree::Taxonomy.find_by_name!("Logged")

taxons = [
  {
    :name => "首页",
    :taxonomy => main_menu,
    :parent => "MainMenu",
    :page_context => 1,
    :position => 1
  },
  {
    :name => "产品介绍",
    :taxonomy => main_menu,
    :parent => "MainMenu",
  },
  {
    :name => "博客",
    :taxonomy => main_menu,
    :parent => "MainMenu",
  },
  {
    :name => "常见问题",
    :taxonomy => main_menu,
    :parent => "MainMenu",
  },
  {
    :name => "联系我们",
    :taxonomy => main_menu,
    :parent => "MainMenu",
  },
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Spree::Taxon.find_by_name!(taxon_attrs[:parent])
    Spree::Taxon.create!(taxon_attrs)
  end
end
