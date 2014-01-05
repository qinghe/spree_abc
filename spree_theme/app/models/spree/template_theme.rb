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
    belongs_to :foreign_template_release, :class_name=>"TemplateRelease", :foreign_key=>"release_id"
    
    scope :by_layout,  lambda { |layout_id| where(:page_layout_root_id => layout_id) }
    serialize :assigned_resource_ids, Hash
    scope :within_site, lambda { |site|where(:site_id=> site.id) }
    scope :imported, where("release_id>0")
    
    before_destroy :remove_relative_data
    attr_accessible :site_id,:page_layout_root_id,:title
    
    class << self
      # template has page_layout & param_values
      # 
      def create_plain_template( section, title, attrs={})
        #create a theme first.
        site_id = SpreeTheme.site_class.current.id
        template = TemplateTheme.create({:site_id=>site_id,:title=>title}) do|template|
          #fix Attribute was supposed to be a Hash, but was a String
          template.assigned_resource_ids={}
        end
        page_layout_root = template.add_section( section ) 
        template.update_attribute("page_layout_root_id",page_layout_root.id)
        template
      end
      
      def native
        self.within_site(SpreeTheme.site_class.current )
      end
      
      def foreign
        self.within_site(SpreeTheme.site_class.designsite )
      end      
    end
    
    
    begin 'for page generator'  
      # * params
      #   * usage - may be [ehtml, css, js]
      def file_name(usage)
        if usage.to_s == 'ehtml'
          "l#{page_layout_root_id}_t#{id}.html.erb"
        else
          "l#{page_layout_root_id}_t#{id}.#{usage}"
        end        
      end
    end
    
    begin 'edit template'
      #import theme into current site
      #only create template record, do not copy param_value,page_layout,template_file...
      # * params
      #   * resource_config - new configuration for resource
      def import(resource_config={})
        raise ArgumentError unless self.template_releases.exists?
        #only released template is importable
        #create theme record
        new_theme = self.dup
        #set resource to site native
        new_theme.assigned_resource_ids = resource_config
        new_theme.title = "Imported "+ new_theme.title
        new_theme.site_id = SpreeTheme.site_class.current.id
        new_theme.release_id = self.template_releases.last.id
        new_theme.save!
        new_theme
      end
      
      # theme from design shop has been imported into current site
      def has_imported?
        # theme should has page_layout, param_values      
        raise ArgumentError if self.release_id>0
        themes = TemplateTheme.native.imported.includes(:foreign_template_release)
        themes.select{|theme| theme.foreign_template_release.theme_id == self.id}.present?
      end
      
      def has_native_layout?
        !self.class.exists?(["page_layout_root_id=? and id<?", self.page_layout_root_id, self.id])        
      end
      # apply to website
      def apply
        SpreeTheme.site_class.current.update_attribute(:theme_id,self.id)
      end
      
      #apply to webiste
      def applied?
        
      end
      
      # Usage: user want to copy this layout&theme to new for editing or backup.
      #        we need copy param_value and theme_images
      #        note that it is only for root. 
      def copy_to_new()
    
        original_layout = self.page_layout    
        #copy new whole tree
        new_layout = original_layout.copy_to_new
        #create theme record
        new_theme = self.dup
        new_theme.page_layout_root_id = new_layout.id
        new_theme.save!
        
        #copy param values
        #INSERT INTO tbl_temp2 (fld_id)    SELECT tbl_temp1.fld_order_id    FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
        table_name = ParamValue.table_name
        
        table_column_names = ParamValue.column_names
        table_column_names.delete('id')
        
        table_column_values  = table_column_names.dup
        table_column_values[table_column_values.index('page_layout_root_id')] = new_layout.id
        table_column_values[table_column_values.index('theme_id')] = new_theme.id
        
        #copy param value from origin to new.
        sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE  (theme_id =#{self.id})! 
        self.class.connection.execute(sql)
        #update layout_id to new_layout.id    
        for node in new_layout.self_and_descendants
          original_node = original_layout.self_and_descendants.select{|item| (item.section_id == node.section_id) and (item.section_instance==node.section_instance) }.first
          #correct param_values
          ParamValue.update_all(["page_layout_id=?", node.id],["theme_id=? and page_layout_id=?",new_theme.id, original_node.id])
          #correct template.assigned_resource_ids
          if new_theme.assigned_resource_ids[original_node.id].present?             
            new_theme.assigned_resource_ids[node.id] = new_theme.assigned_resource_ids.delete(original_node.id)            
          end
        end
        if new_theme.assigned_resource_ids.present?
          new_theme.save
        end
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
        obj = nil
        if section.root? 
          section_instance = 1
          if selected_page_layout.present?
            raise ArgugemntError, 'only container could has child section' unless selected_page_layout.section.section_piece.is_container       
            whole_tree = selected_page_layout.root.self_and_descendants
            section_instance = whole_tree.select{|xnode| xnode.section_id==section.id}.size.succ
          end
          attrs[:title]||="#{section.title}#{section_instance}"        
          obj = PageLayout.create do|obj|
            obj.section_id, obj.section_instance=section.id, section_instance
            obj.assign_attributes( attrs )
            obj.root_id = selected_page_layout.root_id if selected_page_layout.present?
            obj.site_id = SpreeTheme.site_class.current.id
            obj.is_full_html = section.section_piece.is_root?
          end
          if selected_page_layout.present?
            obj.move_to_child_of(selected_page_layout)
          else
            obj.update_attribute("root_id",obj.id)
          end
          #copy the default section param value to the layout
          obj.add_param_value(self)
        end
        obj
      end
      
      # ex. get dialog section
      def find_section_by_usage( usage )
        PageLayout.includes(:section=>:section_piece).where(["#{PageLayout.table_name}.root_id=? and #{SectionPiece.table_name}.usage=?",self.page_layout_root_id, usage]).first
      end
      
      def dialog_content_container_selector
        dialog = find_section_by_usage( 'dialog' )
        dialog_content_container = dialog.section.leaves.includes(:section_piece).select{|section| section.section_piece.is_container?}.first
        dialog.css_selector(dialog_content_container)+"_inner"
      end
                
    end
    begin 'export&import'
      # export to yaml, include page_layouts, param_values, template_files
      # it is a hash with keys :template, :param_values, :page_layouts
      def serializable_data
        template = self.class.find(self.id,:include=>[:param_values,:page_layout=>:full_set_nodes])
        hash ={:template=>template, :param_values=>template.param_values, :page_layouts=>template.page_layout.full_set_nodes,
            :template_files=>template.template_files,:template_releases=>template.template_releases
            } 
        hash      
      end
      
      # it would delete existing one first, then import
      # params
      #   file - opened file 
      def self.import_into_db( file )
        # rake task require class 
        Spree::ParamValue; Spree::PageLayout; Spree::TemplateFile;Spree::TemplateRelease;
        serialized_hash = YAML::load(file)
        template = serialized_hash[:template]
        transaction do 
          if self.exists?(template[:id])
            existing_template = self.find(template[:id])          
            existing_template.destroy
          end
          #site id is 1 in exported yml, in spree_abc, design.dalianshops.com is 2
          site = SpreeTheme.site_class.find_by_domain( 'design.dalianshops.com' )  
          connection.insert_fixture(template.attributes.merge('site_id'=>site.id), self.table_name)
          # we need new template id
          # template = self.find_by_title template.title
          serialized_hash[:param_values].each do |record|
            table_name = ParamValue.table_name
            connection.insert_fixture(record.attributes.except('id'), table_name)          
          end
          serialized_hash[:page_layouts].each do |record|
            table_name = PageLayout.table_name
            connection.insert_fixture(record.attributes.merge('site_id'=>site.id), table_name)          
          end
          serialized_hash[:template_files].each do |record|
            table_name = TemplateFile.table_name
            connection.insert_fixture(record.attributes, table_name)          
          end        
          serialized_hash[:template_releases].each do |record|
            table_name = TemplateRelease.table_name
            connection.insert_fixture(record.attributes, table_name)          
          end
        end        
      end
    end
    def remove_relative_data
      if self.has_native_layout?
        self.page_layout.destroy
      end
    end
    
    begin 'assigned resource'
      # all menus used by this theme, from param values which pclass='db'
      # param_value.pvalue should be menu root id
      # return menu roots
      def assigned_menus

      end
      
      # get assigned menu by specified page_layout_id
      # params:
      #   resource_position: get first( position 0 ) of assigned resources by default
      #     logged_and_unlogged_menu required this feature
      def assigned_resource_id( resource_class, page_layout, resource_position=0 )
        #resource_id = 0
        resource_key = get_resource_class_key(resource_class)
        if assigned_resource_ids.try(:[],page_layout.id).try(:[],resource_key).present?
          resource_id = assigned_resource_ids[page_layout.id][resource_key][resource_position]
        end
        resource_id||0
      end
    
      # assign resource to page_layout node
      def assign_resource( resource, page_layout, resource_position=0 )
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?        
        resource_key = get_resource_class_key(resource.class)
        unless( self.assigned_resource_ids[page_layout.id].try(:[],resource_key).try(:[], resource_position) ==  resource.id )
          self.assigned_resource_ids[page_layout.id]||={}
          self.assigned_resource_ids[page_layout.id][resource_key]||=[]
          self.assigned_resource_ids[page_layout.id][resource_key][resource_position] = resource.id 
        end
        #Rails.logger.debug "assigned_resource_ids=#{assigned_resource_ids.inspect}"
        self.save! 
      end
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
    
    
      def get_resource_class_key( resource_class)
        resource_class.to_s.underscore.to_sym
      end
    end    
  end
end