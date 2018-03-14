class AddImageStyleParamIntoPageLayout < ActiveRecord::Migration[5.1]
  def change
    #制作模板时，产品图片的尺寸是多样的， 即使预先定义多个也不能满足，
    #通过aliyun图片服务可以实时生成任意尺寸图片
    # 一般图片尺寸, 取值为 mini,small,medium,large,custom
    # 逗号(,)分隔，后面是当产品图片图片为多个时，产品图片的索引
    # 示例： medium : 取尺寸为medium，索引为0的产品图片
    #        mini,1 : 取尺寸为mini，索引为1的产品图片
    #       large/mini: 大图尺寸为large, 缩略图尺寸为mini
    add_column :spree_page_layouts, :image_param, :string, limit: 24

  end

end
