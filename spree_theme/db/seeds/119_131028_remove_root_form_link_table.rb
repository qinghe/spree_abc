section_piece = Spree::SectionPiece.find 'root'

section_piece.section_piece_params.each{|spp|
  if ['table', 'table_title','td','th','cell','form','form_title','label','input','form_error','a','a_h'].include? spp.class_name
    spp.destroy
  end
}
