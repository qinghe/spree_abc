#add feature, show address/delivery summary 

previous_partials = {}
<% @order.checkout_steps.each{|step|  if @order.passed_checkout_step? step %>
<%= "previous_partials.#{step}="%> "<%=j( render :partial => 'form_wrapper', :format => :html, :locals => { :state => step, :order => @order } ) %>"
<%  end  } %>
partial = "<%=j render :partial => 'form_wrapper', :format => :html, :locals => { :state => @order.state, :order => @order } %>"
$step = ($ '#checkout_<%= @order.state %>')
error = "<%= flash[:error] %>"

stepHandler = new SinglePageCheckout.StepHandler $step, partial, error, previous_partials
stepHandler.replaceCheckoutStep()

$step.find('button.previous').click (event)->   
  SinglePageCheckout.StepHandler.enableStep $step.prev()

# if order.complete? redirect_to thankyou page,  ex. pay by check
# if payment is alipay, spree_alipay should support ajax?