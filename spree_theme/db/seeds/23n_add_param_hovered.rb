# add param link:hover
section_piece = find_section_piece 'hover-effect-expansion-container'

hovered = { "editor_id"=>4,  "class_name"=>"block_hovered", "pclass"=>"css", "param_category_id"=>101,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
unless Spree::SectionPieceParam.where( hovered ).present?
  create_section_piece_param( section_piece, hovered)
end