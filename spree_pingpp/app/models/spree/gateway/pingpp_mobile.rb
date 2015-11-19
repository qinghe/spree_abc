require "pingpp"
module Spree
  class Gateway::PingppMobile < Gateway::PingppBase

    def auto_capture?
      true
    end

  end
end
