# set container width 100%

section = Spree::Section.includes(section_params: :section_piece_param).where(
  spree_section_piece_params: {class_name: 'block',editor_id: 2}, title: 'container' ).first

if section.section_params.size == 1
  sp = section.section_params.first
  sp.default_value['21'] = 'width:100%'
  sp.default_value['21unset'] = bool_false
  sp.save!
else
  raise 'more section params named block'
end
