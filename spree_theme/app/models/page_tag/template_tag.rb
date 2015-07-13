require 'action_view/helpers/tag_helper'
require 'action_view/helpers/asset_tag_helper.rb'
module PageTag
#                 template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
# template is collection of page_layout. each page_layout is section instance
  class TemplateTag < Base
    #include ActionView::Helpers::TagHelper #add method content_tag
    include ActionView::Helpers::AssetTagHelper

    class WrappedPageLayout < WrappedModel
      self.accessable_attributes=[:id,:title,:current_data_source,:wrapped_data_source_param, :data_filter,:current_contexts, :context_either?,
         :get_content_param_by_key, :get_data_source_param_by_key, :is_container?, :is_image?, :is_zoomable_image?, :effects, :section_pieces, :content_css_class]
      attr_accessor :section_id, :page_layout, :parent

      delegate *self.accessable_attributes, to: :page_layout
      alias_attribute :template, :collection_tag

      def initialize(collection_tag, page_layout, section_id)
        self.collection_tag = collection_tag
        self.page_layout = page_layout
        self.section_id = section_id
      end

      def section
        page_layout.sections.select{|section| section.id == section_id }.first
      end

      #Usage: css selector for current section piece instance
      #       we may need css selector for current section instance
      def piece_selector
        if self.page_layout.id and self.section_id
          "s_#{self.to_key}"
        end
      end

      # section piece have no html, only some css, in this case section_selector is required for css which apply to whole section
      # ex. container title.
      def section_selector
        "s_#{page_layout.id}_#{page_layout.section_id}"
      end

      # some css apply to children but all descendants, so we need a selector to get children
      # this selector indicate it is child of some parent
      # ex. content_layout.
      def as_child_selector
        "c_#{page_layout.parent_id}"
      end
      # some css apply to children but all descendants, so we need a selector to get children
      # this selector refer to its children
      def child_selector
        "c_#{page_layout.id}"
      end

      def to_key
        "#{page_layout.id}_#{section_id}"
      end

      def assigned_menu_id( resource_position=0 )
        assigned_id =  self.collection_tag.theme.assigned_resource_id(SpreeTheme.taxon_class, page_layout, resource_position)
        if assigned_id==0
          assigned_id = page_layout.ancestors.collect{|ancestor|
            self.collection_tag.theme.assigned_resource_id(SpreeTheme.taxon_class, ancestor, resource_position)
          }.select{| ancestor_assigned_id | ancestor_assigned_id >0 }.last.to_i #last could be nil
        end
        assigned_id
      end
      def assigned_image_id
        self.collection_tag.theme.assigned_resource_id(Spree::TemplateFile, page_layout)
      end
      def assigned_text_id
        self.collection_tag.theme.assigned_resource_id(Spree::TemplateText, page_layout)
      end
      # start from 1
      def nth_of_siblings
        self.collection_tag.cached_page_layouts.values.select{|pl| pl.parent_id == page_layout.parent_id && pl != page_layout && pl.lft < page_layout.lft }.size + 1
      end

      # view content image_style ex. taxon_name, render as <a> or <span>?
      def clickable?
        # first bit is clickable
        get_content_param_by_key(:clickable)
      end

      def hoverable?
        # first bit is clickable
        get_content_param_by_key(:hoverable)
      end

      def zoomable?
        is_zoomable_image? && get_content_param_by_key(:zoomable)
      end

      def lightboxable?
        is_image? && get_content_param_by_key(:lightboxable)
      end
      # view content as grid.
      def column_count
        is_container? ?  get_content_param_by_key( :model_count_in_row ) : 0
      end

      def per_page
        return 0 if current_data_source.blank?
        is_container? ?  get_data_source_param_by_key( :per_page ).to_i : 0
      end

      def pagination_enable?
        # only container could have pagination
        is_container? && get_data_source_param_by_key( :pagination_enable )
      end

      def attribute_name
        get_data_source_param_by_key( :attribute_name ) || 'name'
      end

      def truncate_at
        get_content_param_by_key(:truncate_at)
      end

      def datetime_style
        get_content_param_by_key(:datetime_style)
      end
      # get href from
      #   content_param > current_data_item > default(home)
      def href
        if clickable?
           return page_layout.href if get_content_param_by_key( :context ) > 0
           return self.collection_tag.running_data_item.path if self.collection_tag.running_data_item.present?
        end
      end
    end

    attr_accessor :param_values_tag, :menus_tag, :images_tag, :text_tag, :blog_posts_tag
    delegate :css, :to => :param_values_tag
    delegate :menu,:menu2, :to => :menus_tag
    delegate :image, :to => :images_tag
    delegate :text, :to => :text_tag
    delegate :theme, :current_page_tag,  :to => :page_generator
    delegate :section_selector, :to =>:current_piece

    attr_accessor :current_piece
    #we have to store it in template, or missing after select another page_layout.
    attr_accessor :running_data_sources, :running_data_items, :running_data_source_sction_pieces, :cached_section_pieces

    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.param_values_tag = ::PageTag::ParamValues.new(self)
      self.menus_tag = ::PageTag::Menus.new(self)
      self.images_tag = ::PageTag::TemplateImage.new(self)
      self.text_tag = ::PageTag::TemplateText.new(self)
      self.running_data_sources = []
      self.running_data_source_sction_pieces = [] # data_source belongs to section_piece
      self.running_data_items = []
      self.cached_section_pieces = {}
    end

    #Usage: call this in template to initialize current section and section_piece
    #        should call this before call any method.
    #Params: page_layout_id, in fact, it is record of table page_layout. represent a section instance
    #        section_id, it is id of table section, represent a section_piece instance, could be 0. only select page_layout
    #
    def select(page_layout_id, section_id=0)
      page_layout_id = self.current_piece.page_layout.id if page_layout_id==0
      key = "#{page_layout_id}_#{section_id}"
      self.current_piece  = cached_section_pieces[key]
      #current selected section instance, page_layout record
      if self.current_piece.nil?
        page_layout = cached_page_layouts[page_layout_id]
        self.current_piece = WrappedPageLayout.new(self, page_layout, section_id)
        unless page_layout.root?
          parent_page_layout = cached_page_layouts[page_layout.parent_id]
          parent_key = "#{parent_page_layout.id}_0"
          #cached_section_pieces[parent_key] may be nil, we do not select
          self.current_piece.parent = cached_section_pieces[parent_key]
        end
        #Rails.logger.debug "select #{page_layout.title}, section_id=#{section_id}, parent=#{self.current_piece.parent.try(:page_layout).try(:title)}"
        self.cached_section_pieces[key] = self.current_piece
      end
    end

    def products( wrapped_taxon )
      objs = []
      case self.current_piece.current_data_source
        when Spree::PageLayout::DataSourceEnum.gpvs
          #copy from taxons_controller#show
          searcher_params = { taxon: wrapped_taxon.resource_taxon_id }.merge(self.current_piece.wrapped_data_source_param ).merge(self.page_generator.resource_options)
          searcher = Spree::Config.searcher_class.new(searcher_params)
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_products
        when Spree::PageLayout::DataSourceEnum.gpvs_theme
          objs = Spree::MultiSiteSystem.with_context_site1_themes{
            searcher_params ={}
            if wrapped_taxon.persisted?
              searcher_params.merge!(:search=>{:in_global_taxon=>wrapped_taxon.model} )
            end
            searcher_params.merge!(self.current_piece.wrapped_data_source_param ).merge!(self.page_generator.resource_options)
            searcher = Spree::Config.searcher_class.new(searcher_params)
            searcher.retrieve_products.theme_only.to_a # explicitly load some records, or default_scope would work when out of this block.
          }
        when Spree::PageLayout::DataSourceEnum.this_product
          #default_taxon.id is 0
          if self.page_generator.resource.kind_of? Spree::Product
            objs = [self.page_generator.resource]
          end
      end
      #Rails.logger.debug "self.current_piece=#{self.current_piece.title},wrapped_taxon = #{wrapped_taxon.name},objs=#{objs.inspect}"
      if objs.present?
        # wrapped_taxon may not be current taxon
        objs = Products.new( self.page_generator, objs, wrapped_taxon )
      end
      objs
    end


    def posts( wrapped_taxon )

      objs = []
      case self.current_piece.current_data_source
        when Spree::PageLayout::DataSourceEnum.blog
          #copy from taxons_controller#show
          searcher_params = {taxon: wrapped_taxon.resource_taxon_id}.merge(self.current_piece.wrapped_data_source_param ).merge(self.page_generator.resource_options)
          searcher = SpreeTheme.post_class.searcher_class.new(searcher_params)
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = searcher.retrieve_posts
        when Spree::PageLayout::DataSourceEnum.post
          if self.page_generator.resource.kind_of? Spree::Post
            objs = [self.page_generator.resource]
          end
      end
      if objs.present?
        objs = Posts.new( self.page_generator, objs, wrapped_taxon)
      end
      objs
    end

    # feature next_post, previous_post
    def related_posts( wrapped_taxon, options = {} )
      data_source = ( options[:data_source] || self.current_piece.current_data_source )
      objs = []
      case data_source
        when Spree::PageLayout::DataSourceEnum.next_post
          if self.page_generator.resource.kind_of? Spree::Post
            item = Spree::PostClassification.where( taxon_id: wrapped_taxon.id, post_id: self.page_generator.resource.id ).first.try(:lower_item).try(:post)
            objs << item if item.present?
          end
        when Spree::PageLayout::DataSourceEnum.previous_post
          if self.page_generator.resource.kind_of? Spree::Post
            item = Spree::PostClassification.where( taxon_id: wrapped_taxon.id, post_id: self.page_generator.resource.id ).first.try(:higher_item).try(:post)
            objs << item if item.present?
          end
      end
      if objs.present?
        objs = Posts.new( self.page_generator, objs, wrapped_taxon)
      end
      objs
    end

    # in template_tag have no method link_to, content_tag, it have to be in base_helper
    def page_attribute(  attribute_name = nil )
      attribute_name ||=  self.current_piece.attribute_name.to_sym

      if attribute_name.to_s =~/root\_/
        # in this case, taxonomy have no running_data_item at this time.
        #   <container with resource menu>
        #     <taxonomy>
        #     <vertical menus>
        #   </container>
        page = self.menu
      else
        page = (self.running_data_item_by_class( Menus::WrappedMenu ) || self.current_page_tag)
      end
      attribute_value = case attribute_name
        when :icon
          if page.icon.present?
            tag('img', :src=>page.icon.url(:original), :u=>'image', :alt=>page.name, :class=>"img-responsive" )
          else
            ''
          end
        when :summary
          page.send attribute_name, self.current_piece.truncate_at
        when :more # it is same as clickable page name
          Spree.t('more')
        when :root_name
          page.name
        else
          page.send attribute_name
      end
      if self.current_piece.clickable? || attribute_name==:more
        html_options = page.extra_html_attributes
        html_options[:href] ||= page.path
        if attribute_name == :summary
          attribute_value << content_tag(:a, "[#{Spree.t(:detail)}]", html_options)
        else
          content_tag(:a, attribute_value, html_options)
        end
      elsif attribute_name==:name
        # make it as link anchor,  wrapped with span, css text-* applicable
        content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{page.id}"}
      else
        attribute_value
      end
    end

    # * params
    #   * attribute_name - symbol :name, :image, :thumbnail
    def product_attribute( attribute_name, options = { } )
      wrapped_product = (self.running_data_item_by_class( Products::WrappedProduct ) )
      if wrapped_product
        attribute_value = case attribute_name
          when :name
            # make it as link anchor
            content_tag :span, wrapped_product.name, {:id=>"p_#{self.current_piece.id}_#{wrapped_product.id}"}
          when :image
            product_image( wrapped_product, options[:image] )
          when :thumbnail
            i = options[:image]
            content_tag(:a, create_product_image_tag( i, wrapped_product, {}, current_piece.get_content_param_by_key(:thumbnail_style)),
            #image_tag(i.attachment.url( current_piece.get_content_param_by_key(:thumbnail_style))),
                         { href: i.attachment.url( current_piece.get_content_param_by_key(:main_image_style)) }
                         )
          else
            wrapped_product.send attribute_name
          end
        if attribute_name== :image && self.current_piece.is_zoomable_image?
          # main image
          # wrap with a, image-zoom required
          # content_tag(:a, attribute_value, { class: 'image-zoom' })
          attribute_value
        elsif self.current_piece.clickable?
          content_tag(:a, attribute_value, { href: wrapped_product.path })
        else
          attribute_value
        end
      end
    end

    def post_attribute(  attribute_name )
      wrapped_post = (self.running_data_item_by_class( Posts::WrappedPost ))
      if wrapped_post
        attribute_value = case attribute_name
          when :cover
            if wrapped_post.cover.present?
              tag('img', :src=>wrapped_post.cover.url(current_piece.get_content_param_by_key(:main_image_style)), :u=>'image', :alt=>'post image', :class=>"img-responsive" )
            end
          when :summary
            wrapped_post.send attribute_name, self.current_piece.truncate_at
          else
            wrapped_post.send attribute_name
          end

        if self.current_piece.clickable?
          html_options = { href: wrapped_post.path }
          if attribute_name == :summary
            attribute_value + content_tag(:a, "[#{Spree.t(:detail)}]", html_options)
          else
            content_tag(:a, attribute_value, html_options)
          end
        elsif attribute_name == :title
          # make it as link anchor
          content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{wrapped_post.id}"}
        elsif attribute_name == :posted_at
          case self.current_piece.datetime_style
            when :date
              pretty_date attribute_value
            else
              pretty_datetime attribute_value
          end

        else
          attribute_value
        end
      end
    end

    def site_attribute( attribute_name )
      website = current_page_tag.website
      attribute_value = ''
      if attribute_name==:favicon
        if website.favicon.present?
          attribute_value = tag('link', href: website.favicon.url(:original), type: "image/x-icon", rel: "shortcut icon" )
        end
      else
        attribute_value = website.send attribute_name
      end
      if self.current_piece.clickable?
        content_tag(:a, attribute_value, {href: '/'})
      elsif attribute_name==:name
        # make it as link anchor
        content_tag :span, attribute_value, {:id=>"p_#{self.current_piece.id}_#{website.site_id}"}
      else
        attribute_value
      end
    end

    def font_awesome
      if current_piece.content_css_class.present?
        attribute_value = content_tag :i, "", { :class=>"fa "+current_piece.content_css_class }
        if self.current_piece.clickable?
          attribute_value = content_tag( :a, attribute_value, { href: self.current_piece.href } )
        end
        attribute_value
      end

    end

    def get_css_classes

      css_classes = ''
      # handling data iteration?
      # Rails.logger.debug "current_piece=#{current_piece.id},#{current_piece.title}, current_piece.is_container?=#{current_piece.is_container?}, self.running_data_sources.present?=#{self.running_data_sources.present?}"
      if current_piece.is_container?
        # page_layout.effects only apply to container, or bit conflict.
        css_classes << current_piece.effects.join(' ')
        if running_data_item.present?
          current_page = self.page_generator.current_page_tag
          column_count = self.running_data_source_sction_piece.column_count
          i = self.running_data_item_index
          #Rails.logger.debug "i=#{i}, column_count=#{column_count}, self.running_data_source_sction_piece=#{self.running_data_source_sction_piece.id}"
          css_classes << ' data_first' if column_count>0 && i==0
          css_classes << ' data_last'  if column_count>0 && ((i+1)%column_count==0)
          css_classes << " data_#{i+1}"

          case running_data_item
          when Menus::WrappedMenu
            css_classes << ' data_current' if running_data_item.current?
            css_classes << ' data_current_ancestor' if current_page.ancestor_ids.include?(running_data_item.id)
          when Products::WrappedProduct
          end

        end
      end
      if current_piece.parent.effects.present?
        css_classes << " child_#{current_piece.nth_of_siblings}"
      end
      css_classes << " zoomable" if current_piece.zoomable?
      css_classes << " hoverable" if current_piece.hoverable?
      css_classes << " lightboxable" if current_piece.lightboxable?

      css_classes

    end


    def cached_page_layouts
      if @cached_page_layouts.nil?
        @cached_page_layouts = theme.page_layout.self_and_descendants().includes(:section).inject({}){ |hash,pl| hash[pl.id]=pl; hash }
      end
      @cached_page_layouts
    end

    def running_data_source
      running_data_sources.last
    end

    def running_data_source_sction_piece
      running_data_source_sction_pieces[ running_data_sources.size - 1 ]
    end

    def running_data_item
      running_data_items[ running_data_sources.size - 1 ]
    end

    def running_data_item_index
      #running_data_source could be array or resource
      case running_data_source
      when ModelCollection, Array #page.products,menu.children
        running_data_source.index( running_data_item)
      else # a page, a product
        0
      end
    end

    def running_data_source=( data_source )
      if data_source.nil?
        running_data_sources.pop
        running_data_source_sction_pieces.pop
        running_data_items.pop
      else
        running_data_sources.push data_source
        running_data_source_sction_pieces[ running_data_sources.size - 1 ] = current_piece
      end
    end
    def running_data_item=( data_item )
      running_data_items[ running_data_sources.size - 1 ] = data_item
    end

    def running_data_item_by_class( klass )
      running_data_items.select{|item| item.is_a? klass }.last
    end

    private
    def create_product_image_tag( image, product, options, style)
      #Rails.logger.debug " image = #{image} product = #{product}, options= #{options}, style=#{style}"
      options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt
      # data-big-image for jqzoom, large=600x600
      options.merge!  'data' => { 'big-image'=> image.attachment.url(:large) }
      image_tag( image.attachment.url(style), options )
    end
    # copy from BaseHelper#define_image_method
    def product_image_by_spree(product, style, options = {})
        if product.images.empty?
          if !product.is_a?(Spree::Variant) && !product.variant_images.empty?
            create_product_image_tag(product.variant_images.first, product, options, style)
          else
            if product.is_a?(Spree::Variant) && !product.product.variant_images.empty?
              create_product_image_tag(product.product.variant_images.first, product, options, style)
            else
              #seems assets digest do not support template .ruby
              #image_tag "noimage/#{style}.png", options
              options.merge!  'data' => { 'big-image'=> "/shops/shared/images/noimage/large.png" } #zoomable required
              image_tag "/shops/shared/images/noimage/#{style}.png", options
            end
          end
        else
          create_product_image_tag(product.images.first, product, options, style)
        end
    end

    # * params
    #   * options - available keys for image_tag
    #   * specified_image - show this image
    def product_image(wrapped_product, specified_image = nil, options = {})
      product = wrapped_product.model
      Spree::MultiSiteSystem.with_context_site_product_images{
        main_image_style = current_piece.get_content_param_by_key(:main_image_style)
        main_image_position = current_piece.get_content_param_by_key(:main_image_position)
        options.merge! itemprop: "image"
        # only main image have title 'click to get lightbox'
        if current_piece.lightboxable?
          options.merge!  title: I18n.t( "theme.product_image.lightboxable")
        end

        if specified_image
          # mainly for feature product image slider
          create_product_image_tag( specified_image, product, options, main_image_style)
        elsif main_image_position>0
          if product.images[main_image_position].present?
            create_product_image_tag(product.images[main_image_position], product, options, main_image_style)
          end
        else
          product_image_by_spree( product, main_image_style, options)
        end
      }
    end

    def pretty_datetime(time)
      [I18n.l(time.to_date, format: :long), time.strftime("%l:%M %p")].join(" ")
    end
    def pretty_date(time)
      I18n.l(time.to_date, format: :long)
    end
  end
end
