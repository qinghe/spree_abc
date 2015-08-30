require 'rails_helper'
describe Spree::TemplateThemeImporter, :type => :model do

  before(:each) do
    Spree::Site.current = create(:site1)
    taxon = create(:taxon_for_duplicator) #
    @importable_template_theme = create(:importable_template_theme )
    @importable_template_theme.assign_resource( taxon )
  end

  context " current site is demo" do
    before( :each ) do
      Spree::Site.current = create(:site2)
    end
    it "should create new template theme" do
      expect{ @importable_template_theme.importer.import(  ) }.to change{ Spree::TemplateTheme.count}.by(1)
    end

    it "should create new template theme with resource" do
      expect{ @importable_template_theme.import_with_resource(  ) }.to change{ Spree::TemplateTheme.count}.by(1)
    end

    it "should create new template theme with taxon" do
      expect{ @importable_template_theme.import_with_resource(  ) }.to change{ Spree::Taxon.count}.by(4)
    end

    context 'a imported template theme' do

      it "destroy imported one" do
        #template.template_releases.stub(:exists?) { true }
        # release first
        #imported_template.has_native_layout?.should be_false
        #imported_template.destroy
      end
    end

  end

end
