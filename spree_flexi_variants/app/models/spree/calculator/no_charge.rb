require_dependency 'spree/calculator'

module Spree
  class Calculator::NoCharge < Calculator
    def self.description
      "This customization has no charge"
    end

    def self.register
      super
      ProductCustomizationType.register_calculator(self)
    end

    def create_options
      # This calculator knows that it needs one CustomizableOption named message
      [
       CustomizableProductOption.create(:name=>"message", :presentation=>"Message")
      ]
    end

    def compute(product_customization, variant=nil)
      return 0
    end

    def valid_configuration?(product_customization)
      true
    end
  end
end
