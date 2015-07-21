# add feature, show address/delivery summary

previous_partials = {}
<% checkout_step_index = @order.checkout_step_index(@order.state) %>
<% if checkout_step_index >0  %>
    <% last_step = @order.checkout_steps[checkout_step_index-1] %>
previous_partials.<%= last_step%> = "<%=j( render :partial => "#{last_step}_summary", :format => :html, :locals => { :state => last_step, :order => @order } ) %>"
<% end %>
partial = "<%=j render :partial => (@client_info.is_mobile ? 'form_wrapper_bootstrap':'form_wrapper'), :format => :html, :locals => { :state => @order.state, :order => @order } %>"
$step = ($ '#checkout_<%= @order.state %>')
error = "<%= flash[:error] %>"

stepHandler = new SinglePageCheckout.StepHandler $step, partial, error, previous_partials
stepHandler.replaceCheckoutStep()

$step.find('button.previous').click (event)->
  SinglePageCheckout.StepHandler.enableStep $step.prev()

# if order.complete? redirect_to thankyou page,  ex. pay by check
# if payment is alipay, spree_alipay should support ajax?
