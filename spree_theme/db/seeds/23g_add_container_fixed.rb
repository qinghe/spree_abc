include SpreeTheme::SectionPieceParamHelper

#table title cell, border,padding
section_piece = Spree::SectionPiece.find 'container-fixed'
fixed_position =  { "editor_id"=>2, "class_name"=>"fixed_position", "pclass"=>"css", "param_category_id"=>7,  "html_attribute_ids"=>"41,40,33,35"}
unless section_piece.section_piece_params.where(:class_name=>'fixed_position').any?
  create_section_piece_param( section_piece, fixed_position)
end



bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

#fixed_container
Spree::Section.where(:title=>'fixed container').each(&:destroy)
fixed_container = Spree::Section.create_section( section_piece_hash['container'].id, {:title=>"fixed container"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'15'=>"height:100px",'15unset'=>bool_false,'101'=>"float:left",'101unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}}
)
fixed_container.add_section_piece(section_piece_hash['container-fixed'].id)
