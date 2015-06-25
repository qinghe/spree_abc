#hover_effect_container
Spree::Section.where(:title=>'hover effect popup menu container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect popup menu container", :content_param=>  Spree::Section::MouseEffect.popup_menu, :usage=>'container'},
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-popup-menu-container'])
