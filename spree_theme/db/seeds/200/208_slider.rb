

bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE

section_piece = find_section_piece 'slider'
unless section_piece.section_piece_params.exists?( :class_name=>'title' )
  slides =  { "editor_id"=>2,  "class_name"=>"slides", "pclass"=>"css", "param_category_id"=>20,  "html_attribute_ids"=>"78,79"}
  create_section_piece_param( section_piece, slides)
end

section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Slider"},
  {'block'=>{'disabled_ha_ids'=>'111','21unset'=>'0','21'=>'width:600px','15unset'=>'0','15'=>'height:200px'},
   'inner'=>{'15hidden'=>bool_true}})

logo.add_section_piece(section_piece_hash['slider'], {'slides'=>{'78unset'=>'0',78=>'width:600px','79unset'=>'0',79=>'height:200px'}})
