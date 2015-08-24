#encoding: utf-8
require 'rails_helper'
describe Spree::TemplateFile do

  it "should has site_id in url and path" do
    #/home/david/git/spree_abc/public/shops/development/2/spree/template_files/11/logo_original.gif
    #/shops/development/2/spree/template_files/11/logo_original.gif?1406963170
    #Spree::TemplateFile.first.attachment.url
    #
  end

  it "should copy" do
    text = Spree::TemplateFile.create!( :theme_id=>1)
    open( File.join Rails.root, 'app','assets', 'images','rails.png' ) do|f|
      text.attachment = f
      text.save!
    end
    text = Spree::TemplateFile.find text.id

    new_text = text.dup
    new_text.save!

    new_text.should be_persisted
    new_text = Spree::TemplateFile.find new_text.id

    File.should exist(new_text.attachment.path )

    text.reload
    File.should exist(text.attachment.path )

    Rails.logger.debug "new id=#{new_text.id} file=#{new_text.attachment.path}"
    Rails.logger.debug "id=#{text.id} file=#{text.attachment.path}"
  end

end
