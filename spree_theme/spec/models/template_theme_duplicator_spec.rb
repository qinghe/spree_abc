require 'spec_helper'
describe Spree::TemplateTheme do

  it "should copy to new" do
     copied_template = template.copy_to_new

     copied_template.page_layout_root_id.should_not eq template.page_layout_root_id

     new_node_ids = copied_template.page_layout.self_and_descendants.collect{|node| node.id }
     template.assigned_resource_ids.keys{| node_id |
       new_node_ids.should include node_id
     }
     original_page_layouts = template.page_layout.self_and_descendants
     copied_template.page_layout.self_and_descendants.size.should eq original_page_layouts.size
     copied_template.param_values.size.should eq template.param_values.size

     copied_template.page_layout.self_and_descendants.each_with_index{|pl,index|
       pl.param_values.size.should eq original_page_layouts[index].param_values.size
       pl.param_values.first.theme_id.should eq copied_template.id
     }
     copied_template.template_files.size.should eq template.template_files.size
     copied_template.current_template_release.should be_blank
  end

end
