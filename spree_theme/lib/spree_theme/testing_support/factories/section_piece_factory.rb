FactoryGirl.define do
  factory :section_piece, class: Spree::SectionPiece do
    title 'section piece'
    html 'this is a section piece'
    #association :section_piece_param, factory: :section_piece_param
  end
  factory :section_piece_container, class: Spree::SectionPiece do
    title 'section piece container'
    html '<div> ~~content~~ </div>'
  end
  
  factory :section_piece_root, class: Spree::SectionPiece do
    title 'section piece root'
    html '<html> ~~content~~ </html>'
  end

end
