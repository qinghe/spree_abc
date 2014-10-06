objs=[
  {"id"=>1, "position"=>1, "is_enabled"=>true, "editor_id"=>1, "slug"=>"general_config" },
  {"id"=>2, "position"=>1, "is_enabled"=>true, "editor_id"=>2, "slug"=>"general_position" },
  {"id"=>3, "position"=>3, "is_enabled"=>true, "editor_id"=>3, "slug"=>"general_hover" },
  #{"id"=>4, "position"=>1, "is_enabled"=>true, "editor_id"=>4, "slug"=>"general_text" },

  {"id"=>4, "position"=>4, "is_enabled"=>true, "editor_id"=>0, "slug"=>"dialog_title" },
  {"id"=>5, "position"=>5, "is_enabled"=>true, "editor_id"=>0, "slug"=>"dialog_content" },
  {"id"=>6, "position"=>6, "is_enabled"=>true, "editor_id"=>0, "slug"=>"title" }, #header3
  {"id"=>10, "position"=>10, "is_enabled"=>true, "editor_id"=>0, "slug"=>"header0" }, #header0
  # a
  {"id"=>11, "position"=>11, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link" },
  {"id"=>12, "position"=>12, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_hover" },
  {"id"=>13, "position"=>13, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected" },
  {"id"=>14, "position"=>14, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected_hover" },
  {"id"=>15, "position"=>15, "is_enabled"=>true, "editor_id"=>4, "slug"=>"unclickable_link" },
  {"id"=>16, "position"=>16, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_depth1" },
  {"id"=>17, "position"=>17, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_depth2" },
  {"id"=>18, "position"=>18, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_depth3" },
  
  {"id"=>20, "position"=>20, "is_enabled"=>true, "editor_id"=>0, "slug"=>"slides" },
  {"id"=>21, "position"=>21, "is_enabled"=>true, "editor_id"=>0, "slug"=>"slide_caption" },
  {"id"=>22, "position"=>22, "is_enabled"=>true, "editor_id"=>0, "slug"=>"bullet_navigator" },
  {"id"=>23, "position"=>23, "is_enabled"=>true, "editor_id"=>0, "slug"=>"arraw_navigator" },
  {"id"=>24, "position"=>24, "is_enabled"=>true, "editor_id"=>0, "slug"=>"thumbnail_navigator" },
  
  #product img
  {"id"=>28, "position"=>28, "is_enabled"=>true, "editor_id"=>0, "slug"=>"image_style" },
  {"id"=>30, "position"=>30, "is_enabled"=>true, "editor_id"=>0, "slug"=>"main_image" },
  {"id"=>31, "position"=>31, "is_enabled"=>true, "editor_id"=>0, "slug"=>"thumb_image" },
  {"id"=>32, "position"=>32, "is_enabled"=>true, "editor_id"=>0, "slug"=>"thumb_image_selected" },

  #form
  {"id"=>39, "position"=>39, "is_enabled"=>true, "editor_id"=>0, "slug"=>"form" },
  {"id"=>40, "position"=>40, "is_enabled"=>true, "editor_id"=>0, "slug"=>"form_title" },
  {"id"=>42, "position"=>42, "is_enabled"=>true, "editor_id"=>0, "slug"=>"label_name" },
  {"id"=>43, "position"=>43, "is_enabled"=>true, "editor_id"=>0, "slug"=>"label_error" },
  {"id"=>44, "position"=>44, "is_enabled"=>true, "editor_id"=>0, "slug"=>"input" },
  {"id"=>45, "position"=>45, "is_enabled"=>true, "editor_id"=>0, "slug"=>"button" },
  {"id"=>46, "position"=>46, "is_enabled"=>true, "editor_id"=>0, "slug"=>"button_hover" },
  #{"id"=>64, "position"=>64, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_selected_hover_background" },
  #{"id"=>65, "position"=>65, "is_enabled"=>true, "editor_id"=>3, "slug"=>"unclickable_link" },
  #table
  {"id"=>78, "position"=>78, "is_enabled"=>true, "editor_id"=>0, "slug"=>"table" },
  {"id"=>79, "position"=>79, "is_enabled"=>true, "editor_id"=>0, "slug"=>"table_title" },
  {"id"=>80, "position"=>80, "is_enabled"=>true, "editor_id"=>2, "slug"=>"cell" },
  {"id"=>81, "position"=>81, "is_enabled"=>true, "editor_id"=>2, "slug"=>"th" },
  {"id"=>82, "position"=>82, "is_enabled"=>true, "editor_id"=>2, "slug"=>"td" },
  #{"id"=>84, "position"=>84, "is_enabled"=>true, "editor_id"=>4, "slug"=>"td_text" },
  ]

Spree::ParamCategory.delete_all              
for ha in objs
  obj = Spree::ParamCategory.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.editor_id=0
  obj.save
end
                
