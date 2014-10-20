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
    #extend FriendlyId
    belongs_to :website, :class_name => SpreeTheme.site_class.to_s, :foreign_key => "site_id"
  
    #belongs_to :website #move it into template_theme_decorator
    # for now template_theme and page_layout are one to one
    belongs_to :page_layout, :foreign_key=>"page_layout_root_id" #, :dependent=>:destroy  #imported theme refer to page_layout of original theme
    has_many :param_values, :foreign_key=>"theme_id", :dependent => :delete_all
    has_many :template_files, :foreign_key=>"theme_id", :dependent => :delete_all
    has_many :template_releases, :foreign_key=>"theme_id", :dependent => :delete_all
    # template_release may be in current or design site
    belongs_to :current_template_release, :class_name=>"TemplateRelease", :foreign_key=>"release_id"
    
    scope :by_layout,  lambda { |layout_id| where(:page_layout_root_id => layout_id) }
    #use string as key instead of integer page_layout.id, exported theme in json, after restore, key is always string
    serialize :assigned_resource_ids, Hash
    scope :within_site, lambda { |site|where(:site_id=> site.id) }
    scope :released, where("release_id>0")
    
    before_validation :fix_special_attributes
    before_destroy :remove_relative_data
    after_create :initialize_page_layout_for_plain_theme
    
    validates :title, presence: true

    attr_accessor :section_root_id, :is_public
    attr_accessible :site_id,:page_layout_root_id,:title, :section_root_id # section_root_id is only required for create- initialize_page_layout
    attr_accessible :assigned_resource_ids, :template_files #import require it.
    
    
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
        self.within_site(SpreeTheme.site_class.designsite ).where(:is_public=>true)
      end        
      
      # original_theme may be attributes in hash
      def fix_related_data_for_copied_theme(new_theme, new_nodes, new_template_files, original_theme, original_nodes, original_template_files, created_at)
          # # update param_values
          original_theme_id = original_theme['id']
          new_theme_id = new_theme.id
          template_file_key = new_theme.get_resource_class_key( Spree::TemplateFile )
          
          original_nodes.each_with_index{|node,index|
            new_node = new_nodes[index]
            ParamValue.where( :theme_id=>original_theme_id, :page_layout_id=>node.id, :created_at=>created_at ).update_all( :page_layout_id=> new_node.id, :page_layout_root_id=>new_theme.page_layout_root_id, :theme_id=>new_theme_id )
            page_layout_key = new_theme.get_page_layout_key(node)
            new_page_layout_key = new_theme.get_page_layout_key(new_node)
            if new_theme.assigned_resource_ids[page_layout_key].present? 
              new_theme.assigned_resource_ids[new_page_layout_key] = new_theme.assigned_resource_ids.delete(page_layout_key)            
            #  # set template_file id with new created        
            #  if new_theme.assigned_resource_ids[new_page_layout_key][template_file_key].present?
            #    new_theme.assigned_resource_ids[new_page_layout_key][template_file_key].each_with_index{|assigned_template_file_id, assigned_template_file_index|
            #      if assigned_template_file_id>0 #has assigned template file, replace it with new id
            #        new_template_file = nil
            #        original_template_files.each_with_index{|attributes, original_template_file_index|
            #          if attributes['id']==assigned_template_file_id
            #            new_template_file = new_template_files[original_template_file_index]
            #            break
            #          end
            #        }
            #        new_theme.assigned_resource_ids[new_page_layout_key][template_file_key][assigned_template_file_index] = new_template_file.id 
            #      end
            #    }
            #  end
              # remove original specify_taxon, taxon, template_file
              begin 
                new_theme.assigned_resources_by_page_layout new_node
              rescue ActiveRecord::RecordNotFound
                new_theme.assigned_resource_ids[new_page_layout_key].clear                 
              end
            end  
          }          
          if created_at.present?
            Spree::TemplateFile.where(:created_at=>created_at, :theme_id=>original_theme_id).update_all( :theme_id=>new_theme_id )
            Spree::TemplateRelease.where(:created_at=>created_at, :theme_id=>original_theme_id).update_all( :theme_id=>new_theme_id )            
          end
          new_theme.save!
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
      #   * usage - may be [ehtml, css, js]
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
        document_file_path( :ehtml )
      end      
      
      def document_file_path( target )
        File.join( document_path, file_name(target) )
      end
      
      #def released?
      #  release_id > 0 
      #end 
    end
    
    begin 'edit template'
      #import theme into current site
      #only create template record, do not copy param_value,page_layout,template_file...
      # * params
      #   * resource_config - new configuration for resource
      def import(new_attributes={})
        raise ArgumentError unless self.template_releases.exists?
        #only released template is importable
        #create theme record
        new_theme = self.dup
        #set resource to site native
        new_theme.title = "Imported "+ new_theme.title
        new_theme.attributes = new_attributes
        new_theme.site_id = SpreeTheme.site_class.current.id
        new_theme.save!
        if new_theme.template_files.present?
          new_theme.template_files.each{|file|
            original_file = new_attributes[:template_files].first
#Rails.logger.debug "#{file.page_layout_id},#{original_file.page_layout_id},#{file.object_id},#{original_file.object_id},#{file.inspect}, #{original_file.inspect}"            
            new_theme.assign_resource( file, PageLayout.find(file.page_layout_id))
          }          
        end
        new_theme
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
        PageLayout.includes(:section=>:section_piece).where(["#{PageLayout.table_name}.root_id=? and #{SectionPiece.table_name}.usage=?",self.page_layout_root_id, usage]).first
      end
      
      def dialog_content_container_selector
        dialog = find_section_by_usage( 'dialog' )
        dialog_content_container = dialog.section.descendants.includes(:section_piece).select{|section| section.section_piece.usage=='dial-cont'}.first
        dialog.css_selector(dialog_content_container)+"_inner"
      end
                
    end
    begin 'export&import'
      # export to yaml, include page_layouts, param_values, template_files
      # it is a hash with keys :template, :param_values, :page_layouts
      def serializable_data
        template = self.class.find(self.id,:include=>[:param_values,:page_layout])
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
            connection.insert_fixture(original_template_attributes, self.table_name)          
          else
            connection.insert_fixture(original_template_attributes.except('id'), self.table_name)
          end
          new_template = self.where( original_template_attributes.slice('created_at','title','page_layout_root_id') ).first
          # we need new template id
          # template = self.find_by_title template.title
          serialized_data['param_values'].each do |record|
            table_name = ParamValue.table_name
            attributes = get_attributes_serialized_data(record).except('id') 
            #for unknown reason param_value.created_at/updated_at may be nil
            attributes['created_at']=created_at
            attributes['updated_at']=attributes['created_at'] if attributes['updated_at'].blank?
            connection.insert_fixture(attributes, table_name)          
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
            table_name = TemplateFile.table_name
            original_template_file_attributes = get_attributes_serialized_data(record)
            attributes = original_template_file_attributes.except('id').merge!('created_at'=>created_at,'theme_id'=>new_template.id)
            connection.insert_fixture(attributes, table_name)  
            new_template_files << TemplateFile.where( attributes.slice('created_at','theme_id') ).first
            original_template_files << original_template_file_attributes         
          end 
          serialized_data['template_releases'].each do |record|
            table_name = TemplateRelease.table_name
            attributes = get_attributes_serialized_data(record).except('id').merge!('created_at'=>created_at,'theme_id'=>new_template.id)
            connection.insert_fixture(attributes, table_name)          
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
      # return array of resources, no nil contained
      def assigned_resources_by_page_layout( page_layout )
        ordered_assinged_resources = []
        SectionPiece.resource_classes.each{|resource_class|
          assgined_resources_contained_nil = assigned_resources( resource_class, page_layout )
          if assgined_resources_contained_nil.present?
            ordered_assinged_resources.concat( assgined_resources_contained_nil.compact)
          end
        }
        ordered_assinged_resources
      end
      
      # all resources used by this theme
      # return menu roots/ images /texts,  if none assgined, return [nil] or []
      def assigned_resources( resource_class, page_layout )
        resource_key = get_resource_class_key(resource_class)
        page_layout_key = get_page_layout_key(page_layout)
        if assigned_resource_ids.try(:[],page_layout_key).try(:[],resource_key).present?
          resource_ids = assigned_resource_ids[page_layout_key][resource_key]
          #in prepare_import, we want to know assigned resources
          #current shop is not designshop, we need use unscope here.
          if resource_ids.include? 0
            resources = resource_ids.collect{|resource_id|
              if resource_id > 0
                resource_class.unscoped.find resource_id
              else
                nil  
              end
            }
          else
            resources = resource_class.unscoped.find resource_ids  
          end
        end
        resources||[]
      end
      
      # get assigned menu by specified page_layout_id
      # params:
      #   resource_position: get first( position 0 ) of assigned resources by default
      #     logged_and_unlogged_menu required this feature
      def assigned_resource_id( resource_class, page_layout, resource_position=0 )
        #resource_id = 0
        resource_key = get_resource_class_key(resource_class)
        page_layout_key = get_page_layout_key(page_layout)
        if assigned_resource_ids.try(:[],page_layout_key).try(:[],resource_key).present?
          resource_id = assigned_resource_ids[page_layout_key][resource_key][resource_position]
        end
        resource_id||0
      end
    
      # assign resource to page_layout node
      def assign_resource( resource, page_layout, resource_position=0 )
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?        
        resource_key = get_resource_class_key(resource.class)
        page_layout_key = get_page_layout_key(page_layout)
        unless( self.assigned_resource_ids[page_layout_key].try(:[],resource_key).try(:[], resource_position) ==  resource.id )
          self.assigned_resource_ids[page_layout_key]||={}
          self.assigned_resource_ids[page_layout_key][resource_key]||=[]
          self.assigned_resource_ids[page_layout_key][resource_key][resource_position] = resource.id 
        end
        #Rails.logger.debug "assigned_resource_ids=#{assigned_resource_ids.inspect}"
        self.save! 
      end
      # unassign resource from page_layout node
      def unassign_resource( resource_class, page_layout, resource_position=0 )
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?        
        resource_key = get_resource_class_key(resource_class)
        page_layout_key = get_page_layout_key page_layout
        self.assigned_resource_ids[page_layout_key]||={}
        self.assigned_resource_ids[page_layout_key][resource_key]||=[]
        self.assigned_resource_ids[page_layout_key][resource_key][resource_position] = 0
        self.save! 
      end
      
      #clear assigned_resource from theme
      def unassign_resource_from_theme!( resource )
        resource_key = get_resource_class_key(resource.class)
        self.assigned_resource_ids.each_pair{|page_layout_key, resourcs|
            if resourcs.key? resource_key
              resourcs[resource_key].each_with_index{|resource_id,idx|
                if resource_id == resource.id
                  assigned_resource_ids[page_layout_key][resource_key][idx] = 0
                end
              }
            end
        }
        self.save!         
      end
      
      def get_page_layout_key( page_layout )
        page_layout.id.to_s
      end
    end
    
    # called in current_page_tag
    # is page_layout valid to taxon, taxon is current page
    def valid_context?(page_layout, taxon)
      specific_taxons = assigned_resources( Spree::SpecificTaxon, page_layout).compact
      specific_taxon_ids = specific_taxons.collect(&:id)
      (page_layout.valid_context?(taxon.current_context)) && (specific_taxon_ids.blank? || specific_taxon_ids.include?(taxon.id))
    end
    
    begin 'param values'
      def html_page
        HtmlPage.new(self)
      end
        
      # param values of self.
      def full_param_values(editor_id=0)
        if editor_id>0
        ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
         :conditions=>["theme_id=? and section_piece_params.editor_id=?", self.id, editor_id],
         :order=>"section_piece_params.editor_id, param_categories.position")
        else
        ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
         :conditions=>["theme_id=?", self.id],
         :order=>"section_piece_params.editor_id, param_categories.position")
        end
      end
    
      def get_resource_class_key( resource_class )
        resource_class.to_s.underscore
      end
    end  
    
    # taxon_id which is assigned to template_theme and its context is index 
    def index_page
      taxon_id = 0
      assigned_taxon_ids = []
      resource_key = get_resource_class_key SpreeTheme.taxon_class 
      if assigned_resource_ids.present?
        assigned_resource_ids.each_pair{|plid, resource_key_and_resource_ids|
          if resource_key_and_resource_ids.key? resource_key
            resource_key_and_resource_ids[resource_key].each{|resource_id|
              assigned_taxon_ids << resource_id if resource_id > 0
            }
          end
        }
        if assigned_taxon_ids.present?
          taxons = SpreeTheme.taxon_class.find(assigned_taxon_ids)
          taxon_home = SpreeTheme.taxon_class.homes.where(["taxonomy_id in (?)", taxons.map(&:taxonomy_id ) ]).first
          if taxon_home.present?
            taxon_id = taxon_home.id
          end
        end        
      end
      taxon_id      
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
        self.update_attribute("page_layout_root_id",page_layout_root.id)
      end      
    end
    
    def try_to_get_resource_ids( resource_class, page_layout )
      resource_key = get_resource_class_key(resource_class)
      page_layout_key = get_page_layout_key page_layout
      assigned_resource_ids.try(:[],page_layout_key).try(:[],resource_key)
    end
    
  end
end
