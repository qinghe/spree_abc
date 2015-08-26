require 'spec_helper'
require 'pp'
describe Spree::TemplateThemeDuplicator, :type => :model do
  let( :template_theme ){ create(:duplicatabl_template_theme) }
  let!(:duplicator) { Spree::TemplateThemeDuplicator.new(template_theme)}

  let(:image) { File.open(File.expand_path('../../fixtures/qinghe.jpg', __FILE__)) }
  let(:params) { {:template_theme=> template_theme, :attachment => image} }

  before(:all) do
    SpreeTheme.site_class.current = create(:fake_site)
  end

  it "should has page_layouts and param_values" do
    template_theme.page_layouts.should be_present
    template_theme.param_values.should be_present
  end

  it "should copy to new" do
    #pp template_theme
    #pp template_theme.page_layouts
    #pp template_theme.param_values
     original_page_layouts = template_theme.page_layouts
     duplicated_template = duplicator.duplicate

     duplicated_template.page_layout_root.should_not eq template_theme.page_layout_root

     duplicated_template.page_layouts.size.should eq original_page_layouts.size
     duplicated_template.param_values.size.should eq template_theme.param_values.size

     duplicated_template.page_layouts.each_with_index{|pl,index|
       pl.param_values.size.should eq Spree::PageLayout.find( pl.copy_from_id).param_values.size
       pl.template_theme_id.should eq duplicated_template.id
     }
     duplicated_template.current_template_release.should be_blank

  end

  context 'with template files' do
    before(:each) do
      @template_file = Spree::TemplateFile.create(params)
    end

    it "will duplciate the template files" do
      # will change the count by 3, since there will be a master variant as well
      expect{duplicator.duplicate}.to change{Spree::TemplateFile.count}.by(1)
    end

    it "has same template files with original" do |variable|
      duplicated_template = duplicator.duplicate
      duplicated_template.template_files.size.should eq template_theme.template_files.size
    end

    context 'with assgined template file' do
      before(:each) do
        template_theme.assign_resource( @template_file, template_theme.page_layout_root )
      end

      it 'should replace obsolete page_layout id' do |variable|
        duplicated_template = duplicator.duplicate
        new_node_ids = duplicated_template.page_layouts.collect{|node| node.id.to_s }
        #{'page_layout_id'=>{"spree/taxon"=>[227]}}
        duplicated_template.assigned_resource_ids.keys{| node_id |
          new_node_ids.should include node_id
        }
      end
    end
  end

end
