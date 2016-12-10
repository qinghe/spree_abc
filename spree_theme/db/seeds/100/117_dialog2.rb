

bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

Spree::Section.where(:title=>'dialog2').each(&:destroy)
dialog = Spree::Section.create_section(section_piece_hash['dialog'], {:title=>"dialog2"})
dialog_container = dialog.add_section_piece(section_piece_hash['container'], 
{ 'inner'=>{'15hidden'=>bool_true, '15'=>'height:598px', 
            '7'=>'border-style:solid solid solid solid', '8'=>'border-width:1px 1px 1px 1px', '6'=>'border-color:#CCCCCC #CCCCCC #CCCCCC #CCCCCC',
            '7unset'=>bool_false,'8unset'=>bool_false,'6unset'=>bool_false
            },
  'block'=>{'21'=>'width:600px','disabled_ha_ids'=>'111', '2'=>'background-color:#FFFFFF','21unset'=>bool_false,'2unset'=>bool_false,}})
dialog_container.add_section_piece(section_piece_hash['dialog-title'])
dialog_container.add_section_piece(section_piece_hash['dialog-content'])

