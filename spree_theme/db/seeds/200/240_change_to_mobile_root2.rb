root2 = Spree::Section.find_by_title('root2 for mobile')

template2 = Spree::TemplateTheme.for_mobile.last

if root2 && template2  
  template2.page_layout.replace_with root2  
end
 