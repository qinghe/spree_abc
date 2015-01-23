
#hover_effect_container
Spree::Section.where(:title=>'hover effect slide container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect slide container",:content_param=>4},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-slide-container'])
