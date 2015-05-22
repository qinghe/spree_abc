partial = "<%=j render :partial => 'form_wrapper', :format => :html, :locals => { :state => @order.state, :order => @order } %>"
$step = ($ '#checkout_<%= @order.state %>')
error = "<%= flash[:error] %>"

stepHandler = new SinglePageCheckout.StepHandler $step, partial, error
stepHandler.replaceCheckoutStep()

$step.find('button.previous').click (event)->   
  SinglePageCheckout.StepHandler.enableStep $step.prev()

# if order.complete? redirect_to thankyou page,  ex. pay by check
# if payment is alipay, spree_alipay should support ajax?