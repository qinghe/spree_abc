class Spree::Api::V1::WechatsController < Spree::Api::BaseController
  skip_before_action :authenticate_user
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :text do |request, content|
    request.reply.text "echo: #{content}" # Just echo
  end
end
