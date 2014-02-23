html_attribute = Spree::HtmlAttribute.find('height')
section_piece = Spree::SectionPiece.find('container')
section_piece_param = section_piece.section_piece_params.find(:first, :conditions=>["editor_id=? and class_name=?", 2, 'block'])

section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )

html_attribute = Spree::HtmlAttribute.find('margin')
section_piece_param = section_piece.section_piece_params.find(:first, :conditions=>["editor_id=? and class_name=?", 2, 'inner'])
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )

html_attribute = Spree::HtmlAttribute.find('padding')
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )
html_attribute = Spree::HtmlAttribute.find('border-width')
section_piece_param.add_param_value_event( html_attribute, Spree::ParamValue::EventEnum[:unset_changed] )
