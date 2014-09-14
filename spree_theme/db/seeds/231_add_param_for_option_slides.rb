include SpreeTheme::SectionPieceParamHelper

# add param option type presentation margin, padding, border,   background
section_piece = Spree::SectionPiece.find 'option-values-in-slide-style'

option_presentation = { "editor_id"=>2,  "class_name"=>"title", "pclass"=>"css", "param_category_id"=>6,  "html_attribute_ids"=>"31,32,7,8,6"}  
unless Spree::SectionPieceParam.where( option_presentation ).present?
  create_section_piece_param( section_piece, option_presentation)
end

option_presentation = { "editor_id"=>3,  "class_name"=>"title", "pclass"=>"css", "param_category_id"=>6,  "html_attribute_ids"=>"2,3,4,5"}  
unless Spree::SectionPieceParam.where( option_presentation ).present?
  create_section_piece_param( section_piece, option_presentation)
end

# 
option_value_large_image = { "editor_id"=>2,  "class_name"=>"large_image", "pclass"=>"css", "param_category_id"=>30,  "html_attribute_ids"=>"31,32,7,8,6" }  
unless Spree::SectionPieceParam.where( option_value_large_image ).present?
  create_section_piece_param( section_piece, option_value_large_image)
end
option_value_large_image = { "editor_id"=>3,  "class_name"=>"large_image", "pclass"=>"css", "param_category_id"=>30,  "html_attribute_ids"=>"2,3,4,5" }  
unless Spree::SectionPieceParam.where( option_value_large_image ).present?
  create_section_piece_param( section_piece, option_value_large_image)
end

#
option_value_thumb_image = { "editor_id"=>2,  "class_name"=>"thumb_image", "pclass"=>"css", "param_category_id"=>31,  "html_attribute_ids"=>"31,32,7,8,6" }  
unless Spree::SectionPieceParam.where( option_value_thumb_image ).present?
  create_section_piece_param( section_piece, option_value_thumb_image)
end
option_value_thumb_image = { "editor_id"=>3,  "class_name"=>"thumb_image", "pclass"=>"css", "param_category_id"=>31,  "html_attribute_ids"=>"2,3,4,5" }  
unless Spree::SectionPieceParam.where( option_value_thumb_image ).present?
  create_section_piece_param( section_piece, option_value_thumb_image)
end
