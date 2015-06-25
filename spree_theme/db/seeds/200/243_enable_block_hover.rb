section_piece_params = Spree::SectionPieceParam.includes(:section_params).where(class_name: 'block_h')


if section_piece_params.any?
  section_piece_params.each{|param|    
    param.update_attributes( class_name: 'hover' )    
    param.section_params.each{|section_param|
      section_param.update_attributes( is_enabled: true)
    }    
  }
end