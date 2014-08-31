include SpreeTheme::SectionPieceParamHelper

# add param link:hover
section_piece = Spree::SectionPiece.find 'menuitem'

link_hover = { "editor_id"=>2,  "class_name"=>"a_h", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"7,8,6"}  
unless Spree::SectionPieceParam.where( link_hover ).present?
  create_section_piece_param( section_piece, link_hover)
end

# add param container:hover, border
section_piece = Spree::SectionPiece.find 'container'
container_hover = { "editor_id"=>2,  "class_name"=>"block_h", "pclass"=>"css", "param_category_id"=>3,  "html_attribute_ids"=>"7,8,6"}  
unless Spree::SectionPieceParam.where( container_hover ).present?
  create_section_piece_param( section_piece, container_hover)
end

# add param container:hover, background
section_piece = Spree::SectionPiece.find 'container'
container_hover = { "editor_id"=>3,  "class_name"=>"block_h", "pclass"=>"css", "param_category_id"=>3,  "html_attribute_ids"=>"2,3,4,5"}  
unless Spree::SectionPieceParam.where( container_hover ).present?
  create_section_piece_param( section_piece, container_hover)
end

# add html_attribute margin into a
spps = Spree::SectionPieceParam.where(:editor_id=>2,:class_name=>'a').all

if spps.size == 1
  margin = Spree::HtmlAttribute.find 31
  padding = Spree::HtmlAttribute.find 32
  spps.first.insert_html_attribute margin, padding  
end

