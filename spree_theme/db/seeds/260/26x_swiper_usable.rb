#swiper
#http://www.swiper.com.cn

section_piece = find_section_piece 'swipper-core'
unless section_piece.section_piece_params.exists?( :class_name=>'slides' )
  slides =  { "editor_id"=>2,  "class_name"=>"slides", "pclass"=>"css", "param_category_id"=>20,  "html_attribute_ids"=>"21,15"}
  create_section_piece_param( section_piece, slides)
end


Spree::Section.where(:title=>'swiper for taxon2').each(&:destroy)
container = Spree::Section.create_section( section_piece_hash['container'], {:title=>"swiper for taxon2"},
{ 'content_layout'=>{'86'=>bool_true,'86unset'=>bool_false}, 'block'=>{'101'=>"float:left",'101unset'=>bool_false,'21'=>'width:100%','21unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true}}
)
container.add_section_piece(section_piece_hash['swipper-core']).add_section_piece(section_piece_hash['swipper-data-taxons-as-background'])
