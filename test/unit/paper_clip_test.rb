#encoding: utf-8
require 'test_helper'
class PaperclipTest < ActiveSupport::TestCase
  def setup
    WebMock.disable!
    #@site = Spree::Site.new(:name=>'ABCD',:domain=>'www.abc.net')
  end

  test "upload image to alipay oss" do
    noimage_path = File.join( Rails.root, 'app', 'assets', 'images','noimage','large.png')
    file = Spree::Image.new
    begin
      File.open( noimage_path ) do |noimage|
        file.attachment = noimage
        #upload to aliyun
        file.save!
      end
    rescue => e
      puts e.inspect
    end
  end

  test "upload taxon icon to alipay oss" do
    noimage_path = File.join( Rails.root, 'app', 'assets', 'images','noimage','large.png')
    file = Spree::Image.new
    begin
      File.open( noimage_path ) do |noimage|
        file.attachment = noimage
        #upload to aliyun
        file.save!
      end
    rescue => e
      puts e.inspect
    end
  end

  def teardown
      WebMock.enable!
  end
end
