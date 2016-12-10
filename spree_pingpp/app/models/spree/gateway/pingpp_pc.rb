require "pingpp"
module Spree
  class Gateway::PingppPc < Gateway::PingppBase

    def auto_capture?
      true
    end


  end
end
