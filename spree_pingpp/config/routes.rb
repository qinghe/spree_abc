Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  patch '/checkout/handle_pingpp', :to => 'checkout#handle_pingpp', as: :handle_pingpp, format: :json

  # alipay get,  upacp_pc post
  match '/pingpp/charge_done', :to=> 'pingpp_status#charge_done', as: :pingpp_charge_done,  via: [:get, :post]
end
