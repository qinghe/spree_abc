


dialog = Spree::Section.create_section(section_piece_hash['container'], {:title=>"dialog3", :usage=>"dialog"},
{ 'inner'=>{'15hidden'=>bool_true, '15'=>'height:598px', '2'=>'background-color:#FFFFFF','2unset'=>bool_false,
            '7'=>'border-style:solid solid solid solid', '8'=>'border-width:1px 1px 1px 1px', '6'=>'border-color:#CCCCCC #CCCCCC #CCCCCC #CCCCCC',
            '7unset'=>bool_false,'8unset'=>bool_false,'6unset'=>bool_false
            },
  'block'=>{'21'=>'width:600px','disabled_ha_ids'=>'111','21unset'=>bool_false}
   })
dialog_container = dialog.add_section_piece(section_piece_hash['container-dialog']).add_section_piece(section_piece_hash['container-form'])
dialog_container.add_section_piece(section_piece_hash['dialog-title'], {  'dialog_title'=>{'2'=>'background-color:#000000','2unset'=>bool_false,'49'=>'color:#FFFFFF','49unset'=>bool_false } } )
dialog_container.add_section_piece(section_piece_hash['dialog-content'], {'dialog_content'=>{'32'=>'padding:10px 30px 20px 30px','32unset'=>bool_false }} )
