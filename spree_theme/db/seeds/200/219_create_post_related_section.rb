
bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE

#section_piece = find_section_piece 'slider'
#unless section_piece.section_piece_params.exists?( :class_name=>'title' )
#  slides =  { "editor_id"=>2,  "class_name"=>"slides", "pclass"=>"css", "param_category_id"=>20,  "html_attribute_ids"=>"78,79"}
#  create_section_piece_param( section_piece, slides)
#end
Spree::Section.where(:title=>'Post title').each(&:destroy)
Spree::Section.where(:title=>'Post time').each(&:destroy)
Spree::Section.where(:title=>'Post author').each(&:destroy)
Spree::Section.where(:title=>'Post body').each(&:destroy)

section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Post title"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['container-link']).add_section_piece(section_piece_hash['post-title'])

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Post time"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['post-time'])

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Post author"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['post-author'])

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Post body"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})
logo.add_section_piece(section_piece_hash['post-body'])
