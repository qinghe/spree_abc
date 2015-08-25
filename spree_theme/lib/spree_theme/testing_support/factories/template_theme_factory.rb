FactoryGirl.define do
  factory :template_theme, class: Spree::TemplateTheme do
    title 'template theme'
    association :page_layout, factory: :page_layout
  end

  factory :published_template_theme, class: Spree::TemplateTheme do
    title 'template theme'
    association :page_layout, factory: :page_layout
    is_public true
    after(:create) do |theme, evaluator|
      create_list(:template_release, 1, template_theme: theme)
    end
  end

  factory :template_release, class: Spree::TemplateRelease do
    name 'tempalte release'
  end

end
