# section param for dialog_overlay and dialog_close
section_piece = Spree::SectionPiece.where( slug: 'logo' ).first

img_size_params =  { "editor_id"=>2,  "class_name"=>"img", "pclass"=>"css", "param_category_id"=>30,  "html_attribute_ids"=>"21,15"}
create_section_piece_param( section_piece, img_size_params)
