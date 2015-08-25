require 'spec_helper'
describe Spree::TemplateTheme do
  let (:template) { create :template_theme }
  let (:section_root) { create :section_root }

  before(:each) do
    SpreeTheme.site_class.current = create(:fake_site)
    @taxon = create(:taxon)
  end

  it "should has valid context" do
    taxon = @taxon
    template.valid_context?( template.page_layout, taxon ).should be_truthy
  end

  it "has document_path" do
    #template.page_layout.site.path
    expect(template.page_layout).to receive(:site).and_return( SpreeTheme.site_class.current )
    template.document_path.should be_present
  end

  it "param_values" do
    template.respond_to?(:param_values).should be_truthy
  end

  it "create plain template" do
    template = Spree::TemplateTheme.create_plain_template(section_root,'Template One')
    template.should be_an_instance_of(Spree::TemplateTheme)
    template.page_layout.should be_an_instance_of(Spree::PageLayout)
    template.page_layout.root?.should be_truthy

    #first_param_value = template.param_values.first
    #first_param_value.page_layout_id.should eq(template.page_layout.id)
    #first_param_value.page_layout_root_id.should eq(template.page_layout.root_id)
  end
  context 'a published template theme' do
    let (:published_template) { create :published_template_theme }

    it "should be importable" do
      imported_template = published_template.import
      published_template.should be_imported
    end
  end

  context 'a imported template theme' do

    it "destroy imported one" do
      #template.template_releases.stub(:exists?) { true }
      # release first
      #imported_template.has_native_layout?.should be_false
      #imported_template.destroy
      #template.page_layout.present?.should be_truthy
    end
  end

  context "assign template file" do
    before(:each) do
      @template_file = create(:template_file)
    end

    it "should assign resource" do
      template_file = @template_file
      template.assign_resource( template_file, template.page_layout )
      template.assign_resource( template_file, template.page_layout, 1 )
      template.assigned_resource_id( Spree::TemplateFile, template.page_layout ).should eq template_file.id
      template.assigned_resource_id( Spree::TemplateFile, template.page_layout, 1 ).should eq template_file.id

      template_resources = template.template_resources
      template_resources.should be_present
    end

    it "should unassign resource" do
      template_file = @template_file
      template.assign_resource( template_file, template.page_layout )
      template.unassign_resource( Spree::TemplateFile, template.page_layout )
      template.assigned_resource_id( Spree::TemplateFile, template.page_layout ).should eq 0

      template.assigned_resources( Spree::TemplateFile, template.page_layout ).compact.should be_blank
    end

  end

  it "should update release id" do
    template_release = template.template_releases.build
    template_release.name = "just a test"
    template_release.save!

    template.reload

    template.release_id.should == template_release.id
  end

  #it "should be applied" do
  #  template.applied?.should be_truthy
  #end

  it "assign attributes" do
    original_title = "it is test"
    theme = Spree::TemplateTheme.new(:title=>original_title)
    theme.attributes = {:assigned_resource_ids=>{}, :template_files=>[]}
    theme.title.should == original_title
  end

  it "should be imported" do
    #open(File.join( SpreeTheme::Engine.root,'db', 'themes', 'template_images', 'logo.gif')) do|f|
    #  template_file = Spree::TemplateFile.new(:attachment=>f, :page_layout_id=>template.page_layout_root_id)
    #  new_template = template.import(:template_files => [template_file] )
    #  new_template.current_template_release.should be_present
    #  new_template.should be_a_kind_of Spree::TemplateTheme
    #  new_template.assigned_resources( Spree::TemplateFile,template.page_layout ).should be_present
    #end
  end


  context 'assigned specific taxon' do
    before(:each) do
      @specific_taxon = create(:specific_taxon)
      template.assign_resource( @specific_taxon, template.page_layout )
    end

    it "should get assigned specific taxon" do
      taxon = @specific_taxon
      template.assigned_resource_id( taxon.class, template.page_layout ).should eq taxon.id
    end

    it "should has invalid context for other taxon" do
      another_taxon = @taxon
      template.valid_context?( template.page_layout, another_taxon ).should be false
    end

    it "should unassign resource from theme after taxon destroy" do
      taxon = @taxon
      template.assign_resource( taxon, template.page_layout )
      taxon.destroy
      template.reload
      template.assigned_resource_id( taxon.class, template.page_layout ).should eq 0
    end
  end


end
