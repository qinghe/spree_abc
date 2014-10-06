
include SpreeTheme::SectionPieceParamHelper
bool_false = Spree::HtmlAttribute::BOOL_FALSE
bool_true =  Spree::HtmlAttribute::BOOL_TRUE

Spree::Section.where(:title=>'Grouped option values selector').each{|section|
  section.update_attribute( :is_enabled, false )  
}
Spree::Section.where(:title=>'container with title').each{|section|
  section.update_attribute( :is_enabled, false )  
}


Spree::Section.where(:title=>'Grouped option values selector2').each(&:destroy)

section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}

logo = Spree::Section.create_section(section_piece_hash['container'].id, {:title=>"grouped option values selector2"},
  {'block'=>{'disabled_ha_ids'=>'111'}, 'inner'=>{'15hidden'=>bool_true}})

logo.add_section_piece( section_piece_hash['container-header0'].id ).add_section_piece( section_piece_hash['container-link'].id ).add_section_piece(section_piece_hash['grouped-option-values-selector'].id)
