require 'spec_helper'
describe Spree::TemplateTheme do
  let (:template) { Spree::TemplateTheme.first }
    
  it "could serialize&unserialize" do
    serializable_data = template.serializable_data    

    new_theme = Spree::TemplateTheme.import_into_db(serializable_data)
    
    
    page_layouts = new_theme.page_layout.self_and_descendants    
    
    page_layouts.size.should == serializable_data['page_layouts'].size
    #template_file same
    #template.assigned_resource_ids updated for new resource_id, like template_file
  end

end