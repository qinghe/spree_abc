=begin
objs=[
  { "is_enabled"=>true, "section_id"=>1, "id"=>1, "root_id"=>1, "parent_id"=>0, "lft"=>1, "rgt"=>10, "section_instance"=>0, "slug"=>"layout1"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>2, "root_id"=>1, "parent_id"=>1, "lft"=>2, "rgt"=>9, "section_instance"=>0, "slug"=>"bd"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>3, "root_id"=>1, "parent_id"=>2, "lft"=>3, "rgt"=>4, "section_instance"=>2, "slug"=>"header"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>4, "root_id"=>1, "parent_id"=>2, "lft"=>5, "rgt"=>8, "section_instance"=>3, "slug"=>"content"},
  { "is_enabled"=>true, "section_id"=>3, "id"=>5, "root_id"=>1, "parent_id"=>4, "lft"=>6, "rgt"=>7, "section_instance"=>0, "slug"=>"menu"}]

  PageLayout.delete_all              
  for ha in objs
    obj = PageLayout.new
    obj.send(:attributes=, ha, false)
    obj.save
  end
=end                

# section slugs= [root,container,menu]
objects = Spree::Section.roots
section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
# puts "section_hash=#{section_hash.keys}"
template = Spree::TemplateTheme.create_plain_template(section_hash['root'], "Template One")
document = template.page_layout
header = template.add_section(section_hash['container'],document, :title=>"Header")
template.add_section(section_hash['logo'], header,:title=>"Logo")
template.add_section(section_hash['hmenu'], header,:title=>"Main menu")

body = template.add_section(section_hash['container'], document, :title=>"content")
footer = template.add_section(section_hash['container'], document, :title=>"footer")

lftnav = template.add_section(section_hash['container'], body, :title=>"lftnav")
main_content = template.add_section(section_hash['container'], body, :title=>"main content")

template.add_section(section_hash['vmenu'], lftnav, :title=>"Categories")

blog_list = template.add_section(section_hash['container'], main_content, :title=>"product list")
blog_detail = template.add_section(section_hash['container'], main_content, :title=>"product detail")
template.add_section(section_hash['product-name'], blog_list, :title=>"product name")
template.add_section(section_hash['product-image'], blog_list, :title=>"product image")


template.add_section(section_hash['product-name'], blog_detail, :title=>"product name")
template.add_section(section_hash['product-description'], blog_detail, :title=>"product description")

blog_list.reload   #reload left, right
blog_detail.reload #reload left, right
blog_list.update_section_context( Spree::PageLayout::ContextEnum.list )
blog_list.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.list].first )

blog_detail.update_section_context( Spree::PageLayout::ContextEnum.detail )
blog_detail.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.detail].first )



template.add_section(section_hash['hmenu'], footer, :title=>"footer menu")
template.add_section(section_hash['text'], footer, :title=>"copyright")
