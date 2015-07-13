#encoding: utf-8
# * 这是一个示例页面
# *    <html> 
# *      <body> hello world!</body> 
# *    </html>
# * 从抽象角度看，一个网站是很多页面组成，每个页面是由html和css。
# * html 表示了页面的布局(html标签如 <div>,<span><ul>)和内容(除标签外的数据，如:上面的 'hello world')，css 表示了页面的样式。
# * 再实践中，常常会有多个页面使用相同的布局和CSS，只是内容不同。如：产品展示页面。 因此，当设计网站是使用模板会简便很多。
# * 基于上述， 模板系统需要支持： 设计网站所有页面，每个页面可以有不同的布局、内容和样式。
# *   1. 添加页面，
# *      每个网站的页面数量是未定的。 但是我们可以所有的页面分成几类：
# *         首页，产品列表， 产品描述， 登陆/注册， 购物车， 结帐， 购物成功，我的账户， 密码恢复。
# *      如果模板提供了这几类页面，网站就可以使用了。
# *      不同的页面有不同的内容， 当创建页面时，需要设定页面的类型。  
# *   2. 设计页面布局，根据html语言的特点， 页面的布局可以看成树型结构，如图所示，每个节点可以是相对独立的一部分页面，或者是容器包含其他节点。
# *      html root - head
# *                - body - logo
# *                       - main menu
# *                       - content - product list- product name
# *                                 - product detail - product name
# *                                                  - add to cart button
# *                                 - cart - cart items
# *                       - footer
# *      我们把节点定义为section, 每一个section由html标签、css和内容组成。 如果一个section是容器，那么它可以包含其他section.
# *      在实际中， 多个页面希望共用logo 、main menu 和 footer, cart只在购物车页面显示。因此每个section可以有页面类型，表示它适用于什么样的页面。
# *       
# *   3. 设计页面内容. 不同的页面有不同的内容，模板的内容有几类： 图片、文字、菜单 、产品信息和表单
# *     图片、文字、菜单 、产品信息都是用户添加的，称为用户资源，用户可以把它分配给相应section,实现展示。
# *     为了便于对产品的管理，我们用taxon作为产品的集合， 一个页面可以由一个或几个taxon的产品构成。   
# *   4. 设计页面样式. CSS设计， 用户通过设置section的css值实现。  
# * 
# * 
# * template_theme, 
# * template_theme, it is a template of site. In a general way, we could say all template are just html and css.   
# * template_theme is composite of page_layout and param_values. page_layout is html, param_value is css
# * 

module Spree
  #it is a theme of page_layout
  class TemplateTheme < ActiveRecord::Base
    include AssignedResource::IdsHandler
    #extend FriendlyId
    TerminalEnum = Struct.new( :desktop, :mobile, :pad, :tv )[0,1,2,3]
    belongs_to :website, :class_name => SpreeTheme.site_class.to_s, :foreign_key => "site_id"
    belongs_to :store, :foreign_key => "store_id"
  
    # for now template_theme and page_layout are one to one
    belongs_to :page_layout, :foreign_key=>"page_layout_root_id" #, :dependent=>:destroy  #imported theme refer to page_layout of original theme
    has_many :param_values, :foreign_key=>"theme_id", :dependent => :delete_all
    has_many :template_files, :foreign_key=>"theme_id", :dependent => :delete_all
    has_many :template_releases, :foreign_key=>"theme_id", :dependent => :delete_all
    # template_release may be in current or design site
    belongs_to :current_template_release, :class_name=>"TemplateRelease", :foreign_key=>"release_id"
    has_one :mobile, foreign_key: "master_id", dependent: :destroy, class_name: self.name
    belongs_to :desktop, foreign_key: "master_id", class_name: self.name
    
    #use string as key instead of integer page_layout.id, exported theme in json, after restore, key is always string
    serialize :assigned_resource_ids, Hash
  
    scope :by_layout, ->(layout_id){ where(:page_layout_root_id => layout_id) }
    scope :within_site, ->(site){ where(:site_id=> site.id) }
    scope :released, ->{ where("release_id>0") }
    scope :published, -> { released.where(:is_public=>true) }
    scope :for_desktop, ->{ where( for_terminal: TerminalEnum.desktop) }
    scope :for_mobile, ->{ where( for_terminal: TerminalEnum.mobile) }
      
    before_validation :fix_special_attributes
    before_destroy :remove_relative_data
    after_create :initialize_page_layout_for_plain_theme
    
    validates :title, presence: true

    attr_accessor :section_root_id
    #attr_accessible :is_public, :site_id,:page_layout_root_id,:title, :section_root_id # section_root_id is only required for create- initialize_page_layout
    #attr_accessible :assigned_resource_ids, :template_files #import require it.
    
    
    class << self
      # template has page_layout & param_values
      # 
      def create_plain_template(  section_root, title, attrs={})
        #create a theme first.
        template = TemplateTheme.create({:title=>title, :section_root_id=>section_root.id}.merge(attrs))         
      end
      
      def native
        self.within_site(SpreeTheme.site_class.current )
      end
      
      def foreign
        where(:store_id=> Spree::Store.designable).published
      end        
      
      # original_theme may be attributes in hash
      def fix_related_data_for_copied_theme(new_theme, new_nodes, new_template_files, original_theme, original_nodes, original_template_files, created_at)
          # # update param_values
          original_theme_id = original_theme['id']
          new_theme_id = new_theme.id
          
          original_nodes.each_with_index{|node,index|
            new_node = new_nodes[index]
            ParamValue.where( :theme_id=>original_theme_id, :page_layout_id=>node.id, :created_at=>created_at ).
              update_all( :page_layout_id=> new_node.id, :page_layout_root_id=>new_theme.page_layout_root_id, :theme_id=>new_theme_id ) 
            obsolete_template_resources = new_theme.template_resources.select{|template_resource| template_resource.page_layout_id== node.id }
            if obsolete_template_resources.present?
              #change page_layout_key, update one of them is done.
              obsolete_template_resources.first.update_attribute!(:page_layout_id, new_node.id )
            end
          }
          # after page_layout_key updated,  confirm template_resource existing.
          new_theme.template_resources.select{|template_resource| template_resource.source.nil? }.each(&:destroy!)
                    
          if created_at.present?
            Spree::TemplateFile.where(:created_at=>created_at, :theme_id=>original_theme_id).update_all( :theme_id=>new_theme_id )
            Spree::TemplateRelease.where(:created_at=>created_at, :theme_id=>original_theme_id).update_all( :theme_id=>new_theme_id )            
          end
          new_theme.save!
      end     

      # copy taxon,text from original_theme to new_theme
      def import_assigned_resource( original_theme,  new_theme ) 
        original_template_resources = original_theme.template_resources
        # new_theme.assigned_resource_ids is empty now
        new_theme.assigned_resource_ids = original_theme.assigned_resource_ids.dup
        # import each resource
        new_theme.template_resources.each{| template_resource |
          unscoped_source = template_resource.unscoped_source
          if unscoped_source.present? && unscoped_source.importable?            
             new_source = template_resource.source_class.find_or_copy unscoped_source
             template_resource.update_attribute!(:source_id, new_source.id)
          else
           template_resource.destroy!
          end
        }
        # assgin imported resource to new_theme
      end
    end
    
    # params
    #   options:  page_only- do not create template_release record, rake task import_theme required it
    def release( release_attributes= {},option={})
      unless option[:page_only]
        template_release = self.template_releases.build
        template_release.name = "just a test"
        template_release.save!
      end
      self.reload # release_id shoulb be template_release.id
      @lg = PageTag::PageGenerator.releaser( self )
      @lg.release  
      self.current_template_release    
    end
    
    begin 'for page generator'  
      # * params
      #   * usage - may be [ruby,ehtml, css, js]
      def file_name(usage)
        if usage.to_s == 'ehtml'
          "l#{page_layout_root_id}.html.erb"
        else
          "l#{page_layout_root_id}.#{usage}"
        end        
      end
      
      # folder name 'layouts' is required, rails look for layout in folder named 'layouts'
      def path
        # self.id is not accurate, it may use imported theme of design site.
        # on other side, design site may release template first time. current_template_release = nil
        if self.current_template_release.present?
          File.join( File::SEPARATOR+'layouts', "t#{self.current_template_release.theme_id}_r#{self.release_id}")
        else
          File.join( File::SEPARATOR+'layouts', "t#{self.id}_r#{self.release_id}")
        end
      end
      
      def document_path
        File.join( page_layout.site.document_path, self.path)
      end
      
      # * params
      #   * targe - could be css, js
      # * return js or css document file path, ex /shops/development/1/layouts/t1_r1/l1_t1.css
      def file_path( target )
        # theme.site do not work.
        File.join(page_layout.site.path, self.path, file_name(target))         
      end
      
      def layout_path
        document_file_path( :ruby )
      end      
      
      def document_file_path( target )
        File.join( document_path, file_name(target) )
      end
      
      #def released?
      #  release_id > 0 
      #end 
    end
    
    begin 'edit template'
      #import template theme design into current site
      #only create template record, do not copy param_value,page_layout,template_file...
      # * params
      #   * resource_config - new configuration for resource
      def import(new_attributes={})
        raise ArgumentError unless self.template_releases.exists? && self.is_public?
        #only released template and :is_public is importable
        #create theme record
        new_theme = self.dup
        #set resource to site native
        new_theme.title = "Imported "+ new_theme.title
        new_theme.attributes = new_attributes
        new_theme.assigned_resource_ids = {}
        new_theme.site_id = Spree::Store.current.site_id
        new_theme.store_id = Spree::Store.current.id
        new_theme.save!
        new_theme
      end
      
      # for simple to user, copy taxonomy as well when import.
      #
      def import_with_resource( new_attributes={})
        self.transaction do
          new_theme = import( new_attributes )          
          #include taxon, image, file, specific-taxon
          self.class.import_assigned_resource( self,  new_theme )          
          new_theme
        end
      end
      
      
      # theme from design shop has been imported into current site or not
      def imported?
        # theme should has page_layout, param_values
        themes = TemplateTheme.native.includes(:current_template_release)
        #theme.current_template_release may be nil
        themes.select{|theme| theme.current_template_release.try(:theme_id) == self.id}.present?        
      end
      
      def has_native_layout?
        !self.class.exists?(["page_layout_root_id=? and id<?", self.page_layout_root_id, self.id])        
      end

      # is theme applied to webiste
      def applied?
        SpreeTheme.site_class.current.template_theme ==self 
      end
      
      # template theme contained native page layout and param values
      def original_template_theme
        self.class.where(:page_layout_root_id=>self.page_layout_root_id).first
      end
      
      # Usage: user want to copy this layout&theme to new for editing or backup.
      #        we need copy param_value and theme_images
      #        note that it is only for root. 
      def copy_to_new()
        created_at =   DateTime.now       
        original_layout = self.page_layout    
        #copy new whole tree
        new_layout = original_layout.copy_to_new
        #create theme record
        new_theme = self.dup
        new_theme.site_id = Spree::Store.current.site_id
        new_theme.store_id = Spree::Store.current.id
        new_theme.release_id = 0 # new copied theme should have no release
        new_theme.page_layout_root_id = new_layout.id
        new_theme.save!
        
        #copy param values
        #INSERT INTO tbl_temp2 (fld_id)    SELECT tbl_temp1.fld_order_id    FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
        table_name = ParamValue.table_name
        
        table_column_names = ParamValue.column_names
        table_column_names.delete('id')        
        table_column_values  = table_column_names.dup
        # method fix_related_data_for_copied_theme handle theme_id, page_layout_root_id
        #table_column_values[table_column_values.index('page_layout_root_id')] = new_layout.id
        #table_column_values[table_column_values.index('theme_id')] = new_theme.id
        table_column_values[table_column_values.index('created_at')] = "'#{created_at.utc.to_s(:db)}'" #=>'2014-08-20 02:48:23'        
        #copy param value from origin to new.
        sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE  (theme_id =#{self.id})! 
        self.class.connection.execute(sql)
        #copy template_files
        new_template_files = self.template_files.map{|template_file|
          new_template_file = template_file.dup
          new_template_file.theme_id = new_theme.id
          new_template_file.created_at = created_at          
          new_template_file.save!
        }
        #update layout_id to new_layout.id    
        self.class.fix_related_data_for_copied_theme(new_theme, new_layout.self_and_descendants, new_template_files, self, original_layout.self_and_descendants, self.template_files, created_at)        
        return new_theme
      end
    
      # Usage: modify layout, add the section instance as child of current node into the layout,
      # Params: 
      #   page_layout, instance of model PageLayout
      #   relationship, 'parent', 'silbing'
      #   selected_page_layout, there should be selected one, except adding root page_layout
      # return: added page_layout record
      # 
      def add_section(section, selected_page_layout=nil, attrs={})
        # check section.section_piece.is_container?
        added_section = nil
        if section.root? 
          section_instance = 1
          if selected_page_layout.present?
            raise 'only container could has child section' unless selected_page_layout.section.section_piece.is_container       
            whole_tree = selected_page_layout.root.self_and_descendants
            section_instance = whole_tree.select{|xnode| xnode.section_id==section.id}.size.succ
          end
          attrs[:title]||="#{section.title}#{section_instance}"        
          added_section = PageLayout.create do|obj|
            obj.section_id, obj.section_instance=section.id, section_instance
            obj.assign_attributes( attrs )
            obj.root_id = selected_page_layout.root_id if selected_page_layout.present?
            obj.site_id = SpreeTheme.site_class.current.id
            obj.is_full_html = section.section_piece.is_root?
          end
          if selected_page_layout.present?
            added_section.move_to_child_of(selected_page_layout)
          else
            added_section.update_attribute("root_id",added_section.id)
          end
          #copy the default section param value to the layout
          added_section.add_param_value(self)
        end
        added_section
      end
      
      # ex. get dialog section
      def find_section_by_usage( usage )
        # ["#{PageLayout.table_name}.root_id=? and #{SectionPiece.table_name}.usage=?",self.page_layout_root_id, usage]
        PageLayout.includes(:section).where( spree_sections:{usage: usage}, root_id: self.page_layout_root_id ).first
      end
      
      def dialog_content_container_selector
        dialog = find_section_by_usage( 'dialog' )
        #dialog_content_container = dialog.section.descendants.includes(:section_piece).select{|section| section.section_piece.usage=='dial-cont'}.first
        dialog.css_selector + " .dialog_content"
      end
                
    end
    begin 'export&import'
      # export to yaml, include page_layouts, param_values, template_files
      # it is a hash with keys :template, :param_values, :page_layouts
      def serializable_data
        template = self.class.includes(:param_values,:page_layout).find(self.id)
        # template.page_layout.self_and_descendants would cause error
        # https://github.com/rails/rails/issues/5303
        # serializable_data.to_yaml, it only get error in rake task.
        # serializable_data.to_json, key is string when load
        hash ={'template'=>template, 'param_values'=>template.param_values, 'page_layouts'=>template.page_layout.self_and_descendants.all,
            'template_files'=>template.template_files,'template_releases'=>template.template_releases
            } 
        hash      
      end
      
      # it would delete existing one first, then import
      # params
      #   file - opened file
      # return imported theme 
      def self.import_into_db( serialized_data, replace_exisit= false )
        new_template = nil
        template = serialized_data.stringify_keys!.fetch 'template'
        transaction do 
          created_at =   DateTime.now       
          # support yaml/json, record is model/hash
          #site id is 1 in exported yml, in spree_abc, design.dalianshops.com is 2
          original_template_attributes = get_attributes_serialized_data(template).merge!( 'created_at'=>created_at )
          
          if self.exists?(original_template_attributes['id'])
            if replace_exisit
              existing_template = self.find(original_template_attributes['id'])                      
              existing_template.destroy
            end
          end

          if replace_exisit
            create!(original_template_attributes)          
          else
            create!(original_template_attributes.except('id'))
          end
          new_template = self.where( original_template_attributes.slice('created_at','title','page_layout_root_id') ).first
          # we need new template id
          # template = self.find_by_title template.title
          serialized_data['param_values'].each do |record|
            attributes = get_attributes_serialized_data(record).except('id') 
            #for unknown reason param_value.created_at/updated_at may be nil
            attributes['created_at']=created_at
            attributes['updated_at']=attributes['created_at'] if attributes['updated_at'].blank?
            ParamValue.create!(attributes)          
          end
          original_nodes = serialized_data['page_layouts']          
          original_nodes = original_nodes.collect{|node| build_model_from_serialized_data( PageLayout, node)}
          new_nodes = PageLayout.copy_to_new( original_nodes )
          new_template.update_attribute(:page_layout_root_id, new_nodes.first.id)
          #serialized_data[:page_layouts].each do |record|
          #  table_name = PageLayout.table_name
          #  connection.insert_fixture(record.attributes, table_name)          
          #end
          new_template_files = [] 
          original_template_files = []
          serialized_data['template_files'].each_with_index do |record, i|
            original_template_file_attributes = get_attributes_serialized_data(record)
            attributes = original_template_file_attributes.except('id').merge!('created_at'=>created_at,'theme_id'=>new_template.id)
            TemplateFile.create!(attributes)  
            new_template_files << TemplateFile.where( attributes.slice('created_at','theme_id') ).first
            original_template_files << original_template_file_attributes         
          end 
          serialized_data['template_releases'].each do |record|
            attributes = get_attributes_serialized_data(record).except('id').merge!('created_at'=>created_at,'theme_id'=>new_template.id)
            TemplateRelease.create!(attributes)          
          end
          fix_related_data_for_copied_theme(new_template, new_nodes, new_template_files, original_template_attributes,  original_nodes, original_template_files, created_at)
        end
        new_template
      end
      
      def self.build_model_from_serialized_data(model_class, serialized_data)
        if serialized_data.kind_of? ActiveRecord::Base
          serialized_data
        else
          #serialized_data.kind_of? Hash, json
          model_attributes = get_attributes_serialized_data( serialized_data )
          model_class.new do|instance|
            model_attributes.each_pair{|key, val|  instance[key] = val  }
          end          
        end
      end
      
      def self.get_attributes_serialized_data( serialized_data )
        # {:a=>1}.shift.last =>1,   serialized_data in json { model_name=>{att1=>att1_value ...}}
        (serialized_data.kind_of? ActiveRecord::Base) ?  serialized_data.attributes : serialized_data.shift.last
      end
    end
    
    def remove_relative_data
      if self.has_native_layout?
        self.page_layout.destroy
      end
    end
    
    begin 'assigned resource'
      
      # get resources order by taxon/image/text,  
      # return array of resources, nil may be contained
      def assigned_resources_by_page_layout( selected_page_layout = nil )
        template_resources.select{|template_resource|
          template_resource.page_layout_id==selected_page_layout.id 
        }.collect(&:source)
      end
      
      # all resources used by this theme
      # return taxon roots/ images /texts,  if none assgined, return [nil] or []
      def assigned_resources( resource_class, selected_page_layout = nil )
        selected_page_layout ||= self.page_layout
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id 
        }.collect(&:source)
      end
      
      # get assigned menu by specified page_layout_id, page_tag required
      # params:
      #   resource_position: get first( position 0 ) of assigned resources by default
      #     logged_and_unlogged_menu required this feature
      def assigned_resource_id( resource_class, selected_page_layout = nil, resource_position=0 )
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id && template_resource.position == resource_position
        }.first.to_i
      end
    
      # assign resource to page_layout node
      def assign_resource( resource, selected_page_layout = nil, resource_position = 0 )
        create_template_resource( selected_page_layout, resource, resource_position ) 
      end
      # unassign resource from page_layout node
      def unassign_resource( resource_class, selected_page_layout, resource_position = 0 )
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id && template_resource.position == resource_position
        }.each(&:destroy!)
         
      end
      
      #clear assigned_resource from theme
      def unassign_resource_from_theme!( resource )
        template_resources.select{|template_resource|
          template_resource.source ==  resource 
        }.each(&:destroy!)
      end
      
    end
    
    # called in current_page_tag
    # is page_layout valid to taxon, taxon is current page
    # return true if taxon is decendant of specific_taxons
    def valid_context?(selected_page_layout, taxon)
      specific_taxons  = assigned_resources( Spree::SpecificTaxon, selected_page_layout).compact
      specific_taxon_ids = specific_taxons.collect(&:id)
      is_valid = (selected_page_layout.valid_context?(taxon.current_context)) 
      if is_valid && specific_taxon_ids.present?
        is_valid = specific_taxon_ids.include?(taxon.id)
        unless is_valid
          is_valid = specific_taxons.map{|specific_taxon| taxon.is_descendant_of?(specific_taxon) }.include?( true )
        end
      end
      is_valid
    end
    
    begin 'param values'
      def html_page
        HtmlPage.new(self)
      end
        
      # param values of self.
      #def full_param_values(editor_id=0)
      #  if editor_id>0
      #  ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
      #   :conditions=>["theme_id=? and section_piece_params.editor_id=?", self.id, editor_id],
      #   :order=>"section_piece_params.editor_id, param_categories.position")
      #  else
      #  ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
      #   :conditions=>["theme_id=?", self.id],
      #   :order=>"section_piece_params.editor_id, param_categories.position")
      #  end
      #end
        
      def get_resource_class_by_key( resource_key )
        # "spree/template_file" => Spree::TemplateFile
        resource_key.classify.constantize
      end
    end  
    
    # taxon_id which is assigned to template_theme and its context is index 
    def home_page
      taxon = nil      
      taxon_ids= template_resources.select{|template_resource|
          template_resource.source_class ==  SpreeTheme.taxon_class 
      }.collect(&:source_id)
      if taxon_ids.present?
        taxons = SpreeTheme.taxon_class.where( id: taxon_ids )      
        taxon = SpreeTheme.taxon_class.homes.where(["taxonomy_id in (?)", taxons.map(&:taxonomy_id ) ]).first
      end
      taxon     
    end
    
    # methods for mobile feature       
    def for_desktop?
      for_terminal == TerminalEnum.desktop
    end
    
    def for_mobile?
      for_terminal == TerminalEnum.mobile
    end
    
    private
    def fix_special_attributes
      if site_id == 0
        self.site_id = SpreeTheme.site_class.current.id
      end
      #fix Attribute was supposed to be a Hash, but was a String
      if new_record? && assigned_resource_ids.blank?
        self.assigned_resource_ids={}
      end
    end
    
    # it is for create plain theme, create would trigger it.
    # copy_to_new,  import do not call it
    def initialize_page_layout_for_plain_theme
      if section_root_id.present?
        root_section = Section.roots.find(section_root_id)
        page_layout_root = add_section( root_section ) 
        self.update_attributes( page_layout_root_id: page_layout_root.id, for_terminal: root_section.for_terminal )
      end      
    end
    
  end
end
