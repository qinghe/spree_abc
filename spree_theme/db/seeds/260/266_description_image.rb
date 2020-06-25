# for sellphone view, we should have width option for product_description images, or image show original size
#image margin, border,padding
section_piece = find_section_piece 'product-description'
img = {"editor_id"=>2, "class_name"=>"img", "pclass"=>"css", "param_category_id"=>28,  "html_attribute_ids"=>"21,31,32,7,8,6"}

create_section_piece_param( section_piece, img)
