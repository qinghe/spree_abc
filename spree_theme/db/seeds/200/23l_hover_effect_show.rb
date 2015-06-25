#hover_effect_container
Spree::Section.where(:title=>'hover effect show container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect show container", :content_param=>Spree::Section::MouseEffect.show},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-show-container'])

#hover_effect_container
Spree::Section.where(:title=>'hover effect expansion container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect expansion container", :content_param=>Spree::Section::MouseEffect.expansion},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-expansion-container'])

#hover_effect_container 
Spree::Section.where(:title=>'hover effect overlay container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect overlay container", :content_param=>  Spree::Section::MouseEffect.overlay},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-overlay-container'])

  
#hover_effect_container
Spree::Section.where(:title=>'hover effect popup container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect popup container", :content_param=>  Spree::Section::MouseEffect.popup},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-popup-container'])
