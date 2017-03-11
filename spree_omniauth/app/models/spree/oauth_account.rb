module Spree
  class OauthAccount < ActiveRecord::Base
    serialize :info, JSON
  end
end
