#
# root - container(assign_taxon: 'category', data_source:menu)
#        - container (data_source:gpvs)  
#           - product_name
#
#
# section slugs= [root,container,menu]
header3 = "test_for_page_resources"
Spree::TemplateTheme.destroy_all(:title => header3)

categories = SpreeTheme.taxon_class.find_by_name("Categories")
objects = Spree::Section.roots
section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
# puts "section_hash=#{section_hash.keys}"
template = Spree::TemplateTheme.create_plain_template(section_hash['root2'], header3)
document = template.page_layout

menu_container = template.add_section(section_hash['container'], document)
gpvs_container = template.add_section(section_hash['container'], menu_container)
product_name = template.add_section(section_hash['product-name'], gpvs_container)

menu_container.update_attribute(:data_source, Spree::PageLayout::DataSourceEnum.menu )
gpvs_container.update_attribute(:data_source, Spree::PageLayout::DataSourceEnum.gpvs )

template.assign_resource(categories, menu_container)

