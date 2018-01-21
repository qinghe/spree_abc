module Spree
  module BaseHelper

    def wechat_config_params(config_options = {})
      account = config_options[:account]
      # copy from module Wechat::Helpers
      # not default account
      config = Wechat.config()
      domain_name = config.trusted_domain_fullname
      api = Wechat.api
      app_id = config.corpid || config.appid

      page_url = if domain_name
                   "#{domain_name}#{controller.request.original_fullpath}"
                 else
                   controller.request.original_url
                 end
      js_hash = api.jsapi_ticket.signature(page_url)

      config_params = {
        debug: !!config_options[:debug],
        app_id: app_id,
        timestamp: js_hash[:timestamp],
        nonce_str: js_hash[:noncestr],
        signature: js_hash[:signature],
        js_api_list: config_options[:api]||[]
      }

    end

    def wechat_share_data( current_page )
      url = if current_page.product_tag.present?
        current_page.product_tag.simple_image( :medium )
      else
        image_url( 'wxshare_missing.png')
      end


      share_data = {
        title: current_page.title.to_json,
        desc: 'this is description',
        link:  controller.request.original_url,
        img_url: url
      }
    end


    private
    # override original, always return style  for feature :aliyun_oss
    # Returns style of image or nil
    def image_style_from_method_name(method_name)
      if method_name.to_s.match(/_image$/) && style = method_name.to_s.sub(/_image$/, '')
        #possible_styles = Spree::Image.attachment_definitions[:attachment][:styles]
        #style if style.in? possible_styles.with_indifferent_access
        style
      end
    end

  end
end
