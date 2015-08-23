=begin
objs=[
  { "is_enabled"=>true, "section_id"=>1, "id"=>1, "root_id"=>1, "parent_id"=>0, "lft"=>1, "rgt"=>10, "section_instance"=>0, "slug"=>"layout1"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>2, "root_id"=>1, "parent_id"=>1, "lft"=>2, "rgt"=>9, "section_instance"=>0, "slug"=>"bd"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>3, "root_id"=>1, "parent_id"=>2, "lft"=>3, "rgt"=>4, "section_instance"=>2, "slug"=>"header"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>4, "root_id"=>1, "parent_id"=>2, "lft"=>5, "rgt"=>8, "section_instance"=>3, "slug"=>"content"},
  { "is_enabled"=>true, "section_id"=>3, "id"=>5, "root_id"=>1, "parent_id"=>4, "lft"=>6, "rgt"=>7, "section_instance"=>0, "slug"=>"menu"}]

  PageLayout.delete_all
  for ha in objs
    obj = PageLayout.new
    obj.send(:attributes=, ha, false)
    obj.save
  end
=end

# section slugs= [root,container,menu]
objects = Spree::Section.roots
section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
# puts "section_hash=#{section_hash.keys}"
template = Spree::TemplateTheme.create_plain_template(section_hash['root2'], "Template One")
document = template.page_layout
header = template.add_section(section_hash['container'],document, :title=>"Header")
template.add_section(section_hash['image'], header,:title=>"Logo")
main_menu = template.add_section(section_hash['hmenu'], header,:title=>"Main menu")

body = template.add_section(section_hash['container'], document, :title=>"content")
footer = template.add_section(section_hash['container'], document, :title=>"footer")
dialog = template.add_section(section_hash['dialog2'], document, :title=>"Dialog")

lftnav = template.add_section(section_hash['container'], body, :title=>"lftnav")
main_content = template.add_section(section_hash['container'], body, :title=>"main content")

template.add_section(section_hash['vmenu'], lftnav, :title=>"Categories")

product_list = template.add_section(section_hash['container'], main_content, :title=>"product list")
product_detail = template.add_section(section_hash['container'], main_content, :title=>"product detail")
product = template.add_section(section_hash['container'], product_list, :title=>"product")
template.add_section(section_hash['product-name'], product, :title=>"product name")
template.add_section(section_hash['product-image'], product, :title=>"product image")
template.add_section(section_hash['product-price'], product, :title=>"product price")

detail_left = template.add_section(section_hash['container'], product_detail, :title=>"left part")
detail_right = template.add_section(section_hash['container'], product_detail, :title=>"right part")

template.add_section(section_hash['product-image-with-thumbnails'], detail_left, :title=>"image with thumbnails")
template.add_section(section_hash['product-properties'], detail_left, :title=>"product_properties")

template.add_section(section_hash['product-name'], detail_right, :title=>"product name")
template.add_section(section_hash['product-description'], detail_right, :title=>"product description")
template.add_section(section_hash['product-price'], detail_right, :title=>"product price")
qty_atc_container = template.add_section(section_hash['container'], detail_right, :title=>"container")
template.add_section(section_hash['product-quantity'], qty_atc_container, :title=>"product quantity")
template.add_section(section_hash['product-atc'], qty_atc_container, :title=>"product atc")

others = template.add_section(section_hash['container'], main_content, :title=>"Others")
  template.add_section(section_hash['taxon-name'], others, :title=>"Taxon name")

cart = template.add_section(section_hash['cart-form'], others, :title=>"Cart")
  template.add_section(section_hash['cart-items'], cart, :title=>"Cart items")
  template.add_section(section_hash['order-total-price'], cart, :title=>"Order total price")

checkout = template.add_section(section_hash['checkout-form'], others, :title=>"Checkout")
  template.add_section(section_hash['ship-form'], checkout, :title=>"Ship form")
  template.add_section(section_hash['payment-form'], checkout, :title=>"Payment form")

thanks = template.add_section(section_hash['container'], others, :title=>"Thanks")
  template.add_section(section_hash['order-number'], thanks, :title=>"Order number")
  template.add_section(section_hash['order-address'], thanks, :title=>"Order address")
  template.add_section(section_hash['order-payment'], thanks, :title=>"Order payment")
  template.add_section(section_hash['order-items'], thanks, :title=>"Order items")


account = template.add_section(section_hash['container'], others, :title=>"Account")
  template.add_section(section_hash['profile'], account, :title=>"Profile")
  template.add_section(section_hash['order-list'], account, :title=>"Order history")

login = template.add_section(section_hash['container'], others, :title=>"Login")
  template.add_section(section_hash['sign-in-form'], login, :title=>"Login form")

signup = template.add_section(section_hash['container'], others, :title=>"Signup")
  template.add_section(section_hash['sign-up-form'], signup, :title=>"Sign up form")

others.reload
  others.update_section_context( [Spree::PageLayout::ContextEnum.cart,Spree::PageLayout::ContextEnum.checkout, Spree::PageLayout::ContextEnum.thanks, Spree::PageLayout::ContextEnum.login, Spree::PageLayout::ContextEnum.signup, Spree::PageLayout::ContextEnum.account] )
cart.reload
  cart.update_section_context( Spree::PageLayout::ContextEnum.cart )
checkout.reload
  checkout.update_section_context( Spree::PageLayout::ContextEnum.checkout )
thanks.reload
  thanks.update_section_context( Spree::PageLayout::ContextEnum.thanks )
account.reload
  account.update_section_context( Spree::PageLayout::ContextEnum.account )
login.reload
  login.update_section_context( Spree::PageLayout::ContextEnum.login )
signup.reload
  signup.update_section_context( Spree::PageLayout::ContextEnum.signup )

product_list.reload   #reload left, right
product_detail.reload #reload left, right
product_list.update_section_context( Spree::PageLayout::ContextEnum.list )
product_list.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.list].first )

product_detail.update_section_context( Spree::PageLayout::ContextEnum.detail )
product_detail.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.detail].first )



template.add_section(section_hash['hmenu'], footer, :title=>"footer menu")
template.add_section(section_hash['text'], footer, :title=>"copyright")
