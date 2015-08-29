module SpreeTheme
  module TestingSupport
    module ControllerRequests

      extend ActiveSupport::Concern

      included do
        routes { Spree::Core::Engine.routes }
      end

      def xhr_post(action, parameters = nil, session = nil, flash = nil)
        parameters ||= {}
        parameters.reverse_merge!(:format => :js)
        xml_http_request(:post, action, parameters, session, flash)
      end

      def xhr_get(action, parameters = nil, session = nil, flash = nil)
        parameters ||= {}
        parameters.reverse_merge!(:format => :js)
        xml_http_request(:get, action, parameters, session, flash)
      end
    end
  end
end
