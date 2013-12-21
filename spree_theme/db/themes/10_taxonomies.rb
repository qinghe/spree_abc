taxonomies = [
  { :name => "MainMenu" },
  { :name => "Unlogged" },
  { :name => "Logged" }
]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.create!(taxonomy_attrs)
end

main_menu = Spree::Taxonomy.find_by_name!("MainMenu")
unlogged = Spree::Taxonomy.find_by_name!("Unlogged")
logged = Spree::Taxonomy.find_by_name!("Logged")

taxons = [
  {
    :name => "Home",
    :taxonomy => main_menu,
    :parent => "MainMenu",
    :mtype => 1,
    :position => 1
  },
  {
    :name => "Login",
    :taxonomy => unlogged,
    :parent => "Unlogged",
    :mtype => 6,
    :position => 1
  },
  {
    :name => "My account",
    :taxonomy => logged,
    :parent => "Logged",
    :mtype => 7,
    :position => 1
  },
]

taxons.each do |taxon_attrs|
  if taxon_attrs[:parent]
    taxon_attrs[:parent] = Spree::Taxon.find_by_name!(taxon_attrs[:parent])
    Spree::Taxon.create!(taxon_attrs, :without_protection => true)
  end
end
