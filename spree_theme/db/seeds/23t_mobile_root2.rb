

root = Spree::Section.create_section(section_piece_hash['root-for-mobile'], {:title=>"root2 for mobile"})
   
root.add_section_piece(section_piece_hash['container-title'])\
  .add_section_piece(section_piece_hash['container-form'])\
  .add_section_piece(section_piece_hash['container-link'])\
  .add_section_piece(section_piece_hash['container-table'])
  
#section = Spree::Section.find_by_title  'root-for-mobile' 

#templates = Spree::TemplateTheme.all(  )

#templates = tempaltes.select{|template| 
#  template.page_layout.section == section
#}

#if root2 && template2  
#  template2.page_layout.replace_with root2  
#end
 