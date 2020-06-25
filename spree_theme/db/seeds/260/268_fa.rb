section_piece = Spree::SectionPiece.where( slug: 'font-awesome' ).first
param_category = Spree::ParamCategory.find( 531 )
fa =  { "editor_id"=>4,  "class_name"=>"fa", "pclass"=>"css", "param_category_id"=>param_category.id,  "html_attribute_ids"=>"24,27,49,16,53,54"}
create_section_piece_param( section_piece, fa)
