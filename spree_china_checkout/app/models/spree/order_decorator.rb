Spree::Order.class_eval do
    #in spree_auth_devise, update_registration: there are code "current_order.state = 'address'"
    #so here we could not define :china_address
    #checkout_flow do
    #  go_to_state :china_address
    #  go_to_state :delivery
    #  go_to_state :payment, :if => lambda { |order| order.payment_required? }
    #  go_to_state :confirm, :if => lambda { |order| order.confirmation_required? }
    #  go_to_state :complete
    #  remove_transition :from => :delivery, :to => :confirm
    #end
    
    
    #def has_available_shipment
    #  return unless has_step?("delivery")
    #  return unless :china_address? # replace address?
    #  return unless ship_address && ship_address.valid?
    #  errors.add(:base, :no_shipping_methods_available) if available_shipping_methods.empty?
    #end
end    


