product_name = Spree::Section.create_section(section_piece_hash['container'], {:title=>"minicart badge"},
  {'block'=>{'disabled_ha_ids'=>'111'},'inner'=>{'15hidden'=>bool_true,'21hidden'=>bool_true,
    '32unset'=> bool_false, '32'=>'padding:3px 7px 3px 7px',
    '64unset'=> bool_false, '64'=>'border-radius:10px 10px 10px 10px',
    '2unset'=> bool_false, '2'=>'background-color:#777777',
    '16unset'=>bool_false,'16'=>'line-height:1em'
    }})

product_name.add_section_piece(section_piece_hash['container-link'],
  {'s_a'=>{'54unset'=>bool_false,'54'=>'text-decoration:none',
    '49unset'=>bool_false,'49'=>'color:white'
    }}).add_section_piece(section_piece_hash['minicart-badge'])
