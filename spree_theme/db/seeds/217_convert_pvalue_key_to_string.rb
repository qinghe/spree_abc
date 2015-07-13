#since import theme from format json, there is no symbol. 
Spree::ParamValue.all.each{|pv|
  if pv.pvalue.present?
    pv.pvalue.stringify_keys!
    pv.save!
  end
}

Spree::TemplateTheme.all.each{|theme|
  if theme.assigned_resource_ids.present?
    theme.assigned_resource_ids.stringify_keys!
    theme.save!    
  end
}
