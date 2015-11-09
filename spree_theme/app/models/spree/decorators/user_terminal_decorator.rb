Spree::PaymentMethod.class_eval do
  belongs_to :user_terminal
end

Spree::TemplateTheme.class_eval do
  belongs_to :user_terminal
end

Spree::Order.class_eval do
  belongs_to :user_terminal

  # make it longer, alipay out_trade_no should unique
  ORDER_NUMBER_LENGTH  = 16
  ORDER_NUMBER_LETTERS = false
  ORDER_NUMBER_PREFIX  = 'R'

  def associate_terminal!( user_terminal )
    self.user_terminal = user_terminal
    attrs_to_set = { user_terminal_id: user_terminal.id }
    assign_attributes(attrs_to_set)

    if persisted?
      # immediately persist the changes we just made, but don't use save since we might have an invalid address associated
      self.class.unscoped.where(id: id).update_all(attrs_to_set)
    end
  end

  def available_payment_methods
    #@available_payment_methods ||= (PaymentMethod.available(:front_end) + PaymentMethod.available(:both)).uniq
    @available_payment_methods ||= (Spree::PaymentMethod.available(:front_end) + Spree::PaymentMethod.available(:both)).uniq.select{|payment_method| payment_method.user_terminal == self.user_terminal }
  end
end
