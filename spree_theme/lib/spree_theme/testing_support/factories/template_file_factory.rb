FactoryGirl.define do
  factory :template_file, class: Spree::TemplateFile do
    template_theme 
    name 'template file'
  end
end
