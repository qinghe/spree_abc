module Spree
  module Context
    module Base
      # use string instead of symbol, parameter from client is string
      # first one is default 
      ContextEnum=Struct.new(:home, :list, :detail, :cart, :account, :checkout, :thanks, :signup, :login, :password, :blog, :post, :logout, :either
                          ) [:home, :list, :detail, :cart, :account, :checkout, :thanks, :signup, :login, :password, :blog, :post, :logout, :""]

      # context may be array, datasource is nil for array.
      # gpvs is available to every context. 
      ContextDataSourceMap = Hash.new( [:taxon, :gpvs, :blog] ).merge!( { ContextEnum.detail=>[:this_product], ContextEnum.post=>[:post] } )
      DataSourceChainMap = {
        :taxon =>[:gpvs,:blog],
        #:gpvs=>[:gpv_product,:gpv_group, :gpv_either],
        #:gpv_product=>[:product_images,:product_options], 
        #:gpv_group=>[:group_products,:group_images],    
        #:group_products=>[:product_images,:product_options],
        :this_product=>[]
        #keys should inclde all data_sources, test required.
        }
      DataSourceEnum  = Struct.new(:gpvs,:this_product,:taxon, :blog, :post )[:gpvs, :this_product, :taxon, :blog, :post]
      DataSourceEmpty = :""
      
      def context_either?
        raise "unimplement"
      end
    end
  end
end
