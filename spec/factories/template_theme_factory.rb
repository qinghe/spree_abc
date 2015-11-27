FactoryGirl.define do
  factory :importable_template_theme, class: Spree::TemplateTheme do
    title 'importable template theme'
    is_public true
    after(:create) do |theme, evaluator|
      create( :page_layout, template_theme: theme)
      create(:template_release, template_theme: theme)
    end

  end
end
