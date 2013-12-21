bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE
sps = Spree::SectionPiece.all
section_piece_hash= sps.inject({}){|h,sp| h[sp.slug] = sp; h}

root = Spree::Section.create_section(section_piece_hash['root'].id, {:title=>"root2"}, 
  {'content_layout'=>{85=>'clear:both'},
   'page'=>{21=>"width:960px",'21unset'=>bool_false, 20=>"min-width:960px", '20hidden'=>bool_true},
   })
   
root.add_section_piece(section_piece_hash['container-title'].id)\
  .add_section_piece(section_piece_hash['container-form'].id)\
  .add_section_piece(section_piece_hash['container-link'].id)\
  .add_section_piece(section_piece_hash['container-table'].id)
  
  

