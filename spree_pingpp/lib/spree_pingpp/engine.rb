module SpreePingpp
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_pingpp'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        spree/frontend/spree_pingpp.js
        billing_integrations/pingpp/alipay_pc_direct.jpg
        billing_integrations/pingpp/alipay_wap.jpg
      ]
    end

    config.to_prepare &method(:activate).to_proc


    config.after_initialize do |app|
      app.config.spree.payment_methods += [
        Spree::Gateway::PingppPc,
        Spree::Gateway::PingppMobile
      ]
    end
  end
end
