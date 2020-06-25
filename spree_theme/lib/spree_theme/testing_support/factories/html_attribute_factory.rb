FactoryGirl.define do
  factory :html_attribute_width, class: Spree::HtmlAttribute do
    css_name 'width'
    pvalues "auto,l1"
    punits "l,%"
    slug 'width'
  end

  factory :html_attribute_height, class: Spree::HtmlAttribute do
    css_name 'height'
    pvalues "auto,l1"
    punits "l,%"
    slug 'height'
  end

  factory :background_image, class: Spree::HtmlAttribute do
    css_name 'background-image'
    pvalues "none,0i"
    punits ""
    slug 'background-image'
  end
end
