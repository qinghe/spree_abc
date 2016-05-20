Spree::Section.where(:title=>'bootstrap dialog').each(&:destroy)

#rename dialog_title to dialog_titlebar
Spree::SectionPieceParam.where( class_name: 'dialog_title' ).update_all( class_name: 'dialog_titlebar' )

dialog = Spree::Section.create_section(section_piece_hash['container'], {:title=>"bootstrap dialog", :usage=>"dialog"},
{ 'inner'=>{'2'=>'background-color:#FFFFFF','2unset'=>bool_false   },
  'block'=>{'21'=>'width:100%','disabled_ha_ids'=>'111','21unset'=>bool_false}
   })
dialog_container = dialog.add_section_piece(section_piece_hash['container-dialog'],{'dialog_overlay'=>{'2'=>'background-color:#FFFFFF','2unset'=>bool_false}}).add_section_piece(section_piece_hash['container-form'])
dialog_container.add_section_piece(section_piece_hash['bootstrap-dialog-title'], {  'dialog_titlebar'=>{'2'=>'background-color:#CCCCCC','2unset'=>bool_false,'49'=>'color:#000000','49unset'=>bool_false } } )
dialog_container.add_section_piece(section_piece_hash['dialog-content'], {'dialog_content'=>{'32'=>'padding:10px 30px 20px 30px','32unset'=>bool_false }} )
