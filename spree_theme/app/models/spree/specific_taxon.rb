#encoding utf8
# a template page_layout is composited of sections
# each section could be specific for assigned taxons, only appear in those pages.
# 示例： 有一个section, 内容是 form表单 “请留言”, 希望只出现在 “联系我们” 页面里。 
# 在 template_themes.assigned_resource_ids 里， 已经有关键字 :spree_taxon，表示分配给section的菜单。
# 这里我们通过继承，创建新的关键字 :spree_specific_taxon
#

module Spree
    
    # comma separated taxon_id
    # it has to be in template_theme, use  assigned_resource_ids  
  class SpecificTaxon < SpreeTheme.taxon_class
  end
end