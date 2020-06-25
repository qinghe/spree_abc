require 'spec_helper'

describe "Wechat", :type => :request do

  let( :wechat_config ) {
    {
      appid: "wxe1e41bc95e1ffc98",
      secret: "5ed88d0faa88ba705a31e650791c5d85",
      token:  "my_token"
    }
  }


  context "bind service" do
    it "bind successfully" do
      get '/open/wechat/callback', auth:{ provider: 'wechat', uid: 7, user_info:{ nickname: 'david', name: 'ZZ'}}
      #Spree::Payment.last.should be_complete
    end
  end


end
