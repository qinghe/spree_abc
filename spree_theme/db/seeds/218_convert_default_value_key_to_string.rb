#since import theme from format json, there is no symbol. 
Spree::SectionParam.all.each{|pv|
  if pv.default_value.present?
    pv.default_value.stringify_keys!
    pv.save!
  end
}

