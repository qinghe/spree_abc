
slider = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Slider scrolling"},
{'block'=>{'disabled_ha_ids'=>'111','21unset'=>'0','21'=>'width:600px','15unset'=>'0','15'=>'height:80px'},
 'inner'=>{'15hidden'=>bool_true}})

slider.add_section_piece(section_piece_hash['slider-scrolling'])
