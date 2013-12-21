#it include string like <%erb%>, fixtures would not work.
def load_section_piece
  records = YAML.load_file(File.join(File.dirname(__FILE__),'spree_section_pieces.yml'))
  records.values.each{|row|
      #Rails.logger.debug "row=#{row.inspect}"
      Spree::SectionPiece.connection.insert_fixture(row, Spree::SectionPiece.table_name)
    
    
  }
end
Spree::SectionPiece.delete_all
load_section_piece