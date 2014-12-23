
bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#hover_effect_container
Spree::Section.where(:title=>'hover effect container').each(&:destroy)
fixed_container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"hover effect container"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
fixed_container.add_section_piece(section_piece_hash['container-hover-effect'])
