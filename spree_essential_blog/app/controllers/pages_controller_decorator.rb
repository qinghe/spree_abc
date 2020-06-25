if defined?(Spree::PagesController)
  Spree::PagesController.instance_eval do
    helper 'spree/posts'
  end
end
