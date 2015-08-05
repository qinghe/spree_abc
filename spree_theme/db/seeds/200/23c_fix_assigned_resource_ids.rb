SpreeTheme.site_class.all.each{|site|
  site.template_themes.each{|template_theme|
    template_theme.assigned_resource_ids.each_pair{|key,val|
      # fix :undefined method `classify' for :"spree/taxon":Symbol
      #spree_theme/app/models/spree/template_resource.rb:44:in `source_class'
      val.stringify_keys!
    }
    template_theme.save!
  }
}
