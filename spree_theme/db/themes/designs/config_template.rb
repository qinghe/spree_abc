template = Spree::TemplateTheme.first
taxon_class = SpreeTheme.taxon_class

categories = taxon_class.find_by_name("Categories")
brands = taxon_class.find_by_name("Brand")
main_menu = taxon_class.find_by_name("MainMenu")

#template.assign_resource(main_menu, main_menu_section)
main_menu_section = template.page_layouts.where(:title=>'Main menu').first
#template.assign_resource(main_menu, main_menu_section)

category_section = template.page_layouts.where(:title=>'Categories').first
template.assign_resource(categories, category_section)
