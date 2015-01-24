

Spree::Section.where(:title=>'Baidu Map').each(&:destroy)


logo = Spree::Section.create_section(section_piece_hash['container'], {:title=>"Baidu Map"},
  {'block'=>{'disabled_ha_ids'=>'111', '21'=>'width:300px','15'=>'height:300px','15unset'=>bool_false,'21unset'=>bool_false}, 'inner'=>{'15hidden'=>bool_true}})

logo.add_section_piece(section_piece_hash['baidu-map'])

# add param inner_width
# add width pv changed event
block_param = Spree::SectionPieceParam.where(:section_piece_id=>2, :class_name=>"block", :editor_id=>2).first
block_param.param_conditions[21]=["pv_changed"]
block_param.save!
#inner
inner_param = Spree::SectionPieceParam.where(:section_piece_id=>2, :class_name=>"inner", :editor_id=>2).first
inner_param.insert_html_attribute( Spree::HtmlAttribute.find(21) )
inner_param.section_params.each{|sp|
  sp.default_value['21hidden'] = bool_true
  sp.save!
  sp.param_values.each{|pv|
    pv.pvalue['21hidden'] = bool_true
    pv.save!
  }
}
