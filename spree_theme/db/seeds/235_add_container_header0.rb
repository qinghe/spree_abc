include SpreeTheme::SectionPieceParamHelper

#table title cell, border,padding
section_piece = Spree::SectionPiece.find 'container-header0'
title =  { "editor_id"=>2, "class_name"=>"s_header0", "pclass"=>"css", "param_category_id"=>10,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, title)
title =  { "editor_id"=>3, "class_name"=>"s_header0", "pclass"=>"css", "param_category_id"=>10,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, title)
title =  { "editor_id"=>4, "class_name"=>"s_header0", "pclass"=>"css", "param_category_id"=>10,  "html_attribute_ids"=>"24,27,49,53,54"}
create_section_piece_param( section_piece, title)
