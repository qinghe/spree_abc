root2 = Spree::Section.find_by_title('root2')

template2 = Spree::TemplateTheme.find_by_id( 2 )

if root2 && template2
  template2.page_layout_root.replace_with root2  
end
