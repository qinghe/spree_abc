module Spree
  class Gateway::PingppResponse
   attr_accessor :authorization

    def success?
      true
    end
  end
end
