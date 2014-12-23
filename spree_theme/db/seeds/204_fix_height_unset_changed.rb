html_attribute = find_html_attribute('height')
section_piece = find_section_piece('container')
section_piece_param = section_piece.section_piece_params.find_by( editor_id: 2, class_name: 'block' )

section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )

html_attribute = find_html_attribute('margin')
section_piece_param = section_piece.section_piece_params.find_by( editor_id: 2, class_name: 'inner' )
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )

html_attribute = find_html_attribute('padding')
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )
html_attribute = find_html_attribute('border-width')
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )
