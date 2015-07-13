=begin
include SpreeTheme::SectionPieceParamHelper

#table title cell, border,padding
section_piece = Spree::SectionPiece.find 'root'
  
table = {"editor_id"=>2, "class_name"=>"table", "pclass"=>"css", "param_category_id"=>78,  "html_attribute_ids"=>"31,7,8,6"}
title = {"editor_id"=>2, "class_name"=>"table_title", "pclass"=>"css", "param_category_id"=>79,  "html_attribute_ids"=>"31,32,7,8,6"}
cell = {"editor_id"=>2, "class_name"=>"cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"32,7,8,6"}

create_section_piece_param( section_piece, table)
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, cell)

title =  { "editor_id"=>3,  "class_name"=>"table_title", "pclass"=>"css", "param_category_id"=>79,  "html_attribute_ids"=>"2,3,4,5"}  
cell =  { "editor_id"=>3,  "class_name"=>"cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"2,3,4,5"}  
th =  { "editor_id"=>3,  "class_name"=>"th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"2,3,4,5"}  
td =  { "editor_id"=>3,  "class_name"=>"td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, cell)
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)

title = { "editor_id"=>4,  "class_name"=>"table_title", "pclass"=>"css", "param_category_id"=>79,  "html_attribute_ids"=>"24,27,49,53,54"}  
cell = { "editor_id"=>4,  "class_name"=>"cell", "pclass"=>"css", "param_category_id"=>80,  "html_attribute_ids"=>"24,27,49,53,54"}  
th = { "editor_id"=>4,  "class_name"=>"th", "pclass"=>"css", "param_category_id"=>81,  "html_attribute_ids"=>"24,27,49,53,54"}  
td = { "editor_id"=>4,  "class_name"=>"td", "pclass"=>"css", "param_category_id"=>82,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, cell)
create_section_piece_param( section_piece, th)
create_section_piece_param( section_piece, td)

  
form = {"editor_id"=>2, "class_name"=>"form", "pclass"=>"css", "param_category_id"=>39,  "html_attribute_ids"=>"31,7,8,6"}
title = {"editor_id"=>2, "class_name"=>"form_title", "pclass"=>"css", "param_category_id"=>40,  "html_attribute_ids"=>"31,32,7,8,6"}
label = {"editor_id"=>2, "class_name"=>"label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"31,32,7,8,6"}
error = {"editor_id"=>2, "class_name"=>"form_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"31,32,7,8,6"}
input = { "editor_id"=>2,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"21,15,31,32,7,8,6"}  
create_section_piece_param( section_piece, form)
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)

title = { "editor_id"=>3,  "class_name"=>"form_title", "pclass"=>"css", "param_category_id"=>40,  "html_attribute_ids"=>"2,3,4,5"}  
label = {"editor_id"=>3, "class_name"=>"label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"2,3,4,5"}
error = {"editor_id"=>3, "class_name"=>"form_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"2,3,4,5"}
input = { "editor_id"=>3,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)

title = { "editor_id"=>4,  "class_name"=>"form_title", "pclass"=>"css", "param_category_id"=>40,  "html_attribute_ids"=>"24,27,49,53,54"}  
label = {"editor_id"=>4, "class_name"=>"label", "pclass"=>"css", "param_category_id"=>42,  "html_attribute_ids"=>"24,27,49,53,54"}
error = {"editor_id"=>4, "class_name"=>"form_error", "pclass"=>"css", "param_category_id"=>43,  "html_attribute_ids"=>"24,27,49,53,54"}
input = { "editor_id"=>4,  "class_name"=>"input", "pclass"=>"css", "param_category_id"=>44,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, title)
create_section_piece_param( section_piece, label)
create_section_piece_param( section_piece, error)
create_section_piece_param( section_piece, input)
=end