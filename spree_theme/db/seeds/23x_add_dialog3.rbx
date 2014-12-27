Spree::Section.find_by_title('dialog').update_attributes(:is_enabled=>false)
Spree::Section.find_by_title('dialog2').update_attributes(:is_enabled=>false)

section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

Spree::Section.where(:title=>'dialog3').each(&:destroy)
dialog = Spree::Section.create_section(section_piece_hash['dialog'], {:title=>"dialog3"})


dialog_container = dialog.add_section_piece(section_piece_hash['container'], 
{ 'inner'=>{'15hidden'=>bool_true, '15'=>'height:598px', 
            '7'=>'border-style:solid solid solid solid', '8'=>'border-width:1px 1px 1px 1px', '6'=>'border-color:#CCCCCC #CCCCCC #CCCCCC #CCCCCC',
            '7unset'=>bool_false,'8unset'=>bool_false,'6unset'=>bool_false,
            '2'=>'background-color:#FFFFFF','2unset'=>bool_false
            },
  'block'=>{'21'=>'width:600px', '21unset'=>bool_false,},
  'content_layout'=>{'disabled_ha_ids'=>'85'}})

dialog_container.add_section_piece(section_piece_hash['dialog-title'])
dialog_content = dialog_container.add_section_piece(section_piece_hash['dialog-content'])
dialog_content.add_section_piece(section_piece_hash['container-form'] ).add_section_piece(section_piece_hash['container-table'] )

