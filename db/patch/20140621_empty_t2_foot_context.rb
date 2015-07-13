page_layout = Spree::PageLayout.where(:title=>'footer', :site_id=>1).first
if page_layout.present?
  page_layout.update_attribute(:section_context, '')
end