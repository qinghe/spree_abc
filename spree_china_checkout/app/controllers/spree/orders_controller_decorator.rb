Spree::OrdersController.class_eval do
  def show
    @order = Spree::Order.find_by_number!(params[:id])

    unless @order.complete?
      redirect_to checkout_state_path( @order.state )
    end

  end
end
