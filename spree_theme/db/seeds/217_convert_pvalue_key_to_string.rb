#since import theme from format json, there is no symbol. 
Spree::ParamValue.all.each{|pv|
  if pv.pvalue.present?
    pv.pvalue = pv.pvalue.stringify_keys
    pv.save!
  end
}
