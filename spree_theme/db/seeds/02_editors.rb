# Editor 
editors = [
  {:id=>2,:slug=>'position'},  
  {:id=>3,:slug=>'color'}, 
  {:id=>4,:slug=>'text'}  
    ]
Spree::Editor.delete_all              
for ha in editors
  obj = Spree::Editor.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.save
end