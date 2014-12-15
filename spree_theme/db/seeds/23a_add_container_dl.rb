root2 = Spree::Section.find_by_title('root2')

container_dl = Spree::SectionPiece.find 'container-dl'

root2.leaves.last.add_section_piece( container_dl.id )
