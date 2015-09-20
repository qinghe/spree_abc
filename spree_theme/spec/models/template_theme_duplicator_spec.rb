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

  context "duplicated" do
    it 'has template_theme' do
      expect{duplicator.duplicate}.to change{Spree::TemplateTheme.count}.by(1)
    end

    it 'has page_layout_root' do      
      expect(duplicator.duplicate.page_layout_root).to be_present
    end

    it 'has page_layouts' do
      page_layout_count = template_theme.page_layouts.count
      expect{duplicator.duplicate}.to change{Spree::PageLayout.count}.by( page_layout_count )
    end

    it 'has param_values' do
      param_value_count = template_theme.param_values.count
      expect{duplicator.duplicate}.to change{Spree::ParamValue.count}.by( param_value_count )
    end

    it 'has param_values for each page_layout' do
      duplicated_template = duplicator.duplicate
      duplicated_template.page_layouts.each_with_index{|pl,index|
        pl.param_values.size.should eq Spree::PageLayout.find( pl.copy_from_id).param_values.count
      }
    end

    it 'has no release' do
      expect( duplicator.duplicate.current_template_release).to be_nil
    end

    it 'has_native_layout?' do
      expect( duplicator.duplicate.has_native_layout?).to be_truthy
    end
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
