# this section is added careless, it is exist in fact.
#Spree::Section.where(:title=>'fixed container stupid').each(&:destroy)
fixed_container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"fixed container useless"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'15'=>"height:100px",'15unset'=>bool_false,'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
fixed_container.add_section_piece(section_piece_hash['container-fixed'])


# clickable sider
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"click effect sider container", :usage =>'container', :content_param=>  Spree::Section::MouseEffect.sider+1 },
  { 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['click-effect-sider'])
