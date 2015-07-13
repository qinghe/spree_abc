module SpreeTheme
  module SectionPieceParamHelper
    def create_section_piece_param( section_piece, section_piece_param_attrs)
      section_piece.section_piece_params.create! do|spp|
        spp.param_conditions={}
        spp.assign_attributes( section_piece_param_attrs,  :without_protection => true)
      end
    end  
  end
end