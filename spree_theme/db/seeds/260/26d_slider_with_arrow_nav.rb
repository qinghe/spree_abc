taxon_slider = Spree::Section.create_section(section_piece_hash['container'], \
  {:title=>"Slider with arrow navigator for taxon images",:usage => 'slider-with-arrow-nav'},\
  {'block'=>{'disabled_ha_ids'=>'111','21unset'=>'0','21'=>'width:600px','15unset'=>'0','15'=>'height:200px'},\
   'inner'=>{'15unset'=>'0','15'=>'height:200px','15hidden'=>bool_true,'21hidden'=>bool_true}})

slider_core = taxon_slider.add_section_piece(section_piece_hash['slider-core'])
slider_core.add_section_piece(section_piece_hash['slider-data-taxons'])
slider_core.add_section_piece(section_piece_hash['slider-arrow-navigator'])
