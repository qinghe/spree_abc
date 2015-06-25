# add unset changed event width/height
block_param = Spree::SectionPieceParam.where(:section_piece_id=>2, :class_name=>"block", :editor_id=>2).first
block_param.param_conditions[21]=['pv_changed','unset_changed']
block_param.save!
