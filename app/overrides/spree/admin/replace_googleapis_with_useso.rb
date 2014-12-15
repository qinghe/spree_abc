#Deface::Override.new(:virtual_path => "spree/admin/shared/_head",
#                     :name => "replace font.googleapis with useso",
#                     :set_attributes => 'link',
#                     :attributes=>{:href=>'//fonts.useso.com/css?family=Open+Sans:400italic,600italic,400,600&subset=latin,cyrillic,greek,vietnamese'})
Deface::Override.new(:virtual_path => "spree/admin/shared/_head",
                     :name => "disable font.googleapis",
                     :remove => 'link')