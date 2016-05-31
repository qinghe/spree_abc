module Spree
  module Context
    module Base

      # taxon|page_layout contexts, mainly it is about special path
      ContextEnum=Struct.new(:home, :list, :detail, :cart, :account, :checkout, :thanks, :signup, :login, :password, :blog, :post, :logout, :search, :either
                          ) [:home, :list, :detail, :cart, :account, :checkout, :thanks, :signup, :login, :password, :blog, :post, :logout, :search, :""]

      # context may be array, if inherited_data_source is empty, [:taxon, :gpvs, :blog, :gpvs_theme] are available datasource for current.
      # gpvs is available to every context.
      ContextDataSourceMap = Hash.new( [:taxon, :gpvs, :blog, :gpvs_theme] ).merge!( { ContextEnum.detail=>[:this_product,:related_products], ContextEnum.post=>[:post] } )
      DataSourceChainMap = {
        taxon: [:gpvs,:blog],
        #:gpvs=>[:gpv_product,:gpv_group, :gpv_either],
        #:gpv_product=>[:product_images,:product_options],
        #:gpv_group=>[:group_products,:group_images],
        #:group_products=>[:product_images,:product_options],
        this_product: [:related_products],
        related_products: [],
        post: []
        #keys should inclde all data_sources, test required.
      }
      DataSourceEnum  = Struct.new(:gpvs, :this_product, :taxon, :blog, :post,:related_posts, :related_products, :gpvs_theme )\
        [:gpvs, :this_product, :taxon, :blog, :post,:related_posts, :related_products, :gpvs_theme]
      DataSourceEmpty = :""

      DataSourceFilterEnum  = Struct.new( :next, :previous )\
        ['next', 'previous']
      def context_either?
        raise "unimplement"
      end
    end
  end
end
