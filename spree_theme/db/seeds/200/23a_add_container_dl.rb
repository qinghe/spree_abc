root2 = Spree::Section.find_by_title('root2')

container_dl = find_section_piece 'container-dl'

root2.leaves.last.add_section_piece( container_dl )
