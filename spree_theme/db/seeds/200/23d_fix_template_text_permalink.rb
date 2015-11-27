SpreeTheme.site_class.all.each{|site|
  site.template_texts.each{|template_text|
    template_text.valid?
    template_text.save!
  }
}
