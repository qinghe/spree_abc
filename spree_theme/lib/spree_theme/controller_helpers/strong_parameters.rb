require 'spree/core/controller_helpers/strong_parameters'
module Spree
  module Core
    module ControllerHelpers
      module StrongParameters

        delegate *Spree::PermittedAttributes::ATTRIBUTES_FOR_THEME,
                 to: :permitted_attributes,
                 prefix: :permitted
      end
    end
  end
end
