Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  patch '/checkout/handle_pingpp', :to => 'checkout#handle_pingpp', as: :handle_pingpp, format: :json

  # called by pingpp webhook
  post  '/pingpp/charge_notify', :to=> 'pingpp_status#charge_notify'
  post  '/pingpp/test_charge_notify', :to=> 'pingpp_status#test_charge_notify'
  # alipay get,  upacp_pc post
  match '/pingpp/charge_done', :to=> 'pingpp_status#charge_done', as: :pingpp_charge_done,  via: [:get, :post]

end
