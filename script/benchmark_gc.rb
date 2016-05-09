#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)


Spree::Site.current = Spree::Site.first
@menu = DefaultTaxonRoot.instance('/').children.first
@theme = Spree::TemplateTheme.first

@lg = PageTag::PageGenerator.generator( @menu, @theme, { searcher_params:{}, pagination_params:{} } )

@controller = Spree::TemplateThemesController.new
@controller.request =ActionDispatch::Request.new({ 'action_dispatch.key_generator' => ActiveSupport::KeyGenerator.new('xxx') })

@lg.context.each_pair{|key,val|
  # expose variable to view
  @controller.instance_variable_set( "@#{key}", val)
}
@controller.instance_variable_set "@client_info", Spree::UserTerminal.first
@controller.instance_variable_set "@current_spree_user", Spree::User.first #fix warden.authenticate, warden is nil
Benchmark.realtime { 
  @controller.render_to_string file: @theme.layout_path(), layout: false
}
