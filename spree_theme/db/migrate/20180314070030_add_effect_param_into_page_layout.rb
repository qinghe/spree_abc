class AddEffectParamIntoPageLayout < ActiveRecord::Migration[5.1]
  def change
    # 制作模板时，有很多特效，如 鼠标点击滑出，鼠标放上放大等
    # 鼠标点击 和 鼠标放上特效，由 Html, js, css 配合实现
    # effect_param 用来定义page_layout 的css class,
    # 以便js找到相应元素，实现特效
    # 示例：:hover_slide, :hover_show, :hover_expansion, :hover_overlay, :hover_popup, :popup_menu, :popup_menu_l, :sider,     :multi_level_menu
    add_column :spree_page_layouts, :effect_param, :string, limit: 32

  end

end
