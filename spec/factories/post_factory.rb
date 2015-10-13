FactoryGirl.define do

  factory :post, class: Spree::Post do
    title 'this is a post'
    body 'post body'
    posted_at DateTime.current
  end
end
