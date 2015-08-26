#encoding: utf-8
require 'rails_helper'
describe Spree::TemplateFile do
  let(:image) { File.open(File.expand_path('../../fixtures/qinghe.jpg', __FILE__)) }
  before(:each) do
    Spree::Site.current = create(:site_demo)
    template_theme =  create(:template_theme)
    @template_file = Spree::TemplateFile.create( name: 'file', template_theme: template_theme )
    @template_file.update_attribute :attachment, image
  end

  it "should has site_id in url and path" do
    #/home/david/git/spree_abc/public/shops/development/2/spree/template_files/11/logo_original.gif
    #/shops/development/2/spree/template_files/11/logo_original.gif?1406963170
    #Spree::TemplateFile.first.attachment.url
    #
  end

  it "should has image" do
    File.should exist(@template_file.attachment.path )
  end

  #it "should not create new template file" do
  #  expect{  Spree::TemplateFile.find_or_copy( @template_file ) }.to change{  Spree::TemplateFile.count}.by(0)
  #end

  #context " current site is demo" do
  #  before( :each ) do
  #    Spree::Site.current = create(:site_demo2)
  #  end
  #  it "should create new template file" do
  #    expect{ described_class.find_or_copy( @template_file ) }.to change{ described_class.count}.by(1)
  #  end
  #end

end
