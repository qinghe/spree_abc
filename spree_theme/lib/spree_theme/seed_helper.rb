module SpreeTheme
  module SeedHelper
    
    def create_section_piece_param( section_piece, section_piece_param_attrs)
      section_piece.section_piece_params.create! do|spp|
        spp.param_conditions={}
        spp.assign_attributes( section_piece_param_attrs )
      end
    end  
    
    
    def find_section_piece( slug )
      section_piece_hash= Spree::SectionPiece.all.inject({}){|h,sp| h[sp.slug] = sp; h}
      section_piece_hash[slug]
    end
    
    def find_html_attribute( slug )
      Spree::HtmlAttribute.friendly.find 'font-weight'
    end
    
  end
end