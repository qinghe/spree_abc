dialog_content = Spree::SectionPiece.where( title: "dialog content").first
dialog_content.section_piece_params.where(class_name: 'inner').update_all( class_name: 'dialog_content')

dialog_title = Spree::SectionPiece.where( title: "dialog title").first
dialog_title.section_piece_params.where(class_name: 'title').update_all( class_name: 'dialog_title')
