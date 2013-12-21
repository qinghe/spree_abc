require 'spec_helper'
describe Spree::TemplateTheme do
  let (:template) { Spree::TemplateTheme.first }
  it "has right param_values" do
    section_params = template.page_layout.self_and_descendants.map{|page_layout| 
      page_layout.section.self_and_descendants.map{|section| section.section_params }.flatten 
      }.flatten    
Rails.logger.debug "section_params.size = #{section_params.size }"
    template.param_values.size.should == section_params.size     
  end
  
  
  it "could serialize&unserialize" do
    serializable_data = template.serializable_data    
    expect(serializable_data).to be_an_instance_of(Hash)
    temp_file = Tempfile.new ['theme', '.yml'], File.join( Rails.root, 'tmp')
    temp_file.write( serializable_data.to_yaml )
    temp_file.size.should be > 0 #cause flush
    File.exists?(temp_file.path).should be_true
    temp_file.rewind
Rails.logger.debug "temp_file=#{temp_file.size}"    
    Spree::TemplateTheme.import_into_db(temp_file)    
    temp_file.close    
  end

  it "create plain template" do
    section = Spree::Section.find('root')
    template = Spree::TemplateTheme.create_plain_template(section,'Template One')
    
    template.should be_an_instance_of(Spree::TemplateTheme)
    template.page_layout.should be_an_instance_of(Spree::PageLayout)
    template.page_layout.root?.should be_true
    template.param_values.count.should be > 0
    
    first_param_value = template.param_values.first 
    first_param_value.page_layout_id.should eq(template.page_layout.id)
    first_param_value.page_layout_root_id.should eq(template.page_layout.root_id)    
  end
  
  it "should copy to new" do
     copy_template = template.copy_to_new     
     copy_template.page_layout_root_id.should_not eq template.page_layout_root_id
     
     new_node_ids = copy_template.page_layout.self_and_descendants.collect{|node| node.id }     
     template.assigned_resource_ids.keys{| node_id |
       new_node_ids.should include node_id
     }     
  end
  
  it "destroy imported one" do
Rails.logger.debug "............strart test import................."    
    #template.template_releases.stub(:exists?) { true }
    template_release = template.template_releases.build
    template_release.name = "just a test"
    template_release.save    
    # release first
    imported_template = template.import
    imported_template.has_native_layout?.should be_false
    imported_template.destroy
    template.page_layout.present?.should be_true    
  end
  
  it "should get resource id" do
    page_layout_tree = template.page_layout.self_and_descendants
    logo = page_layout_tree.select{|pl| pl.title=='Logo'}.first
    template.assigned_resource_id( Spree::TemplateFile, logo ).should be > 0
    template.assigned_resource_id( Spree::TemplateFile, logo, 1 ).should eq 0
    
  end
  
  it "should assign resource" do
    template_file = Spree::TemplateFile.first
    template.assign_resource( template_file, template.page_layout )
    template.assign_resource( template_file, template.page_layout, 1 )
    template.assigned_resource_id( Spree::TemplateFile, template.page_layout ).should eq template_file.id
    template.assigned_resource_id( Spree::TemplateFile, template.page_layout, 1 ).should eq template_file.id    
  end
  
end