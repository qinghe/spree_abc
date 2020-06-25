

Spree::Section.where(:title=>'Taxon tooltips').each(&:destroy)


logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Taxon tooltips"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})

logo.add_section_piece(section_piece_hash['taxon-tooltips'])