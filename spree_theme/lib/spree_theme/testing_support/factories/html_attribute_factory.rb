FactoryGirl.define do
  factory :html_attribute_width, class: Spree::HtmlAttribute do
    css_name 'width'
    pvalues "auto,l1"
    punits "l,%"
    slug 'width'
  end

end
