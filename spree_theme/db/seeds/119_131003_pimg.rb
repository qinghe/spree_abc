

#image margin, border,padding
section_piece = find_section_piece 'product_main_image'
img = {"editor_id"=>2, "class_name"=>"img", "pclass"=>"css", "param_category_id"=>30,  "html_attribute_ids"=>"31,32,7,8,6"}

create_section_piece_param( section_piece, img)

section_piece = find_section_piece 'product_thumbnails'
img = {"editor_id"=>2, "class_name"=>"img", "pclass"=>"css", "param_category_id"=>31,  "html_attribute_ids"=>"31,32,7,8,6"}

create_section_piece_param( section_piece, img)
