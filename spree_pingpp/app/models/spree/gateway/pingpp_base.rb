require "pingpp"
module Spree
  class Gateway::PingppBase < PaymentMethod
    preference :api_key, :string
    preference :app_key, :string
    preference :channels, :string
    #Pingpp.api_key = "YOUR-KEY"

    delegate :purchase, to: :provider

    def provider_class
      Gateway::PingppProvider
    end

    def provider
      provider_class.new( self )
    end

    # it is required to make payment completed.
    def source_required?
      true
    end

    def available_channels
      self.preferred_channels.try(:split, ',') || []
    end

  end
end
