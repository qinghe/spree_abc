#hover_effect_container
#http://www.gtn9.com/user_show.aspx?action=yc&id=C80E6E334F84E131&page=1
Spree::Section.where(:title=>'hover effect fadein container').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect fadein container",:effect_param=>'hover_fadein'},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['hover-effect-fadein-container'])
