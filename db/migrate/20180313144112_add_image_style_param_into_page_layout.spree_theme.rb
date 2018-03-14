# This migration comes from spree_theme (originally 20180313070030)
class AddImageStyleParamIntoPageLayout < ActiveRecord::Migration
  def change
    #制作模板时，产品图片的尺寸是多样的， 即使预先定义多个也不能满足，
    #通过aliyun图片服务可以实时生成任意尺寸图片
    # 一般图片尺寸
    add_column :spree_page_layouts, :image_style_param, :string, limit: 24
  
  end

end
