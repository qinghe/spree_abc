namespace :spree_theme do
  desc "load themes"
  task :load_themes  => :environment do
    Rake::Task["spree_sample:load"].invoke    
    load File.join(SpreeTheme::Engine.root,'db/themes/seed.rb')
  end
  
  desc "reload section_piece.yml"
  task :reload_section_piece => :environment do    
    load File.join(SpreeTheme::Engine.root,'db/seeds/00_section_pieces.rb')
  end
  
  desc "export theme one"
  task :export_theme => :environment do
    template = Spree::TemplateTheme.first
    serializable_data = template.serializable_data
    file_path =  File.join(SpreeTheme.site_class.designsite.document_path, "#{template.id}_#{Time.now.to_i}.yml")
    open(file_path,'w') do |file|
      file.write(serializable_data.to_yaml)
    end
    puts "exported file #{file_path}"
  end
  
  desc "import theme one, accept param THEME_FILE or THEME_PATH," 
       "ex. FILE='spree_theme/db/themes/design/1_138.rb', THEME_PATH='1'"
       "default path=shops/rails_env/shop_id/1_nnn.rb"
  task :import_theme => :environment do
    #template = Spree::TemplateTheme.first
      SpreeTheme.site_class.current = SpreeTheme.site_class.designsite
      
      if ENV['THEME_PATH']
        file_path = File.join(SpreeTheme::Engine.root,'db','themes','designs', "1_*.yml")
      else
        file_path = File.join(SpreeTheme.site_class.designsite.document_path, "1_*.yml")
      end
      file_path = Dir[file_path].sort.last      
    open(file_path) do |file|
      Spree::TemplateTheme.import_into_db(file)
    end    
    puts "imported file #{file_path}"
  end

  desc "get css of template one, rake spree_theme:get_css[1,2,'block']"
  task :get_css, [:page_layout_id,:section_id, :class_name] =>[ :environment ] do |t, args|
    #template = Spree::TemplateTheme.first
    class_name = args.class_name
    lg = PageGenerator.generator( DefaultTaxon.instance, SpreeTheme.site_class.designsite.template_release)
    template = lg.context[:template]
    template.select(args.page_layout_id.to_i, args.section_id.to_i)
    puts "template 1, page_layout_id=#{args.page_layout_id}_#{args.section_id}, #{class_name}= #{template.css(class_name)}"
  end
  
  desc "test theme"
  task :test_theme =>[ :environment ] do |t, args|
    #section_pieces = Spree::SectionPiece.all(:include=>:section_piece_params)    
    #sections =  Spree::Section.all(:include=>{:section_params=>:section_piece_params})
    #page_layouts = Spree::PageLayout.all(:include=>{:section_params=>:section_piece_params})    
    theme = Spree::TemplateTheme.first
    incomplete_page_layouts = []
    # section_param and param_value match each other.
    for page_layout in theme.page_layout.self_and_descendants.includes(:section)     
      if page_layout.section.present?
        section_nodes = page_layout.section.self_and_descendants.includes(:section_params)
        section_params = section_nodes.collect(&:section_params).flatten
        if page_layout.param_values.count!=section_params.count
          incomplete_page_layouts << page_layout
          puts "error:page_layout=#{page_layout.title},#{page_layout.id} param_values and section_params are not match"          
          puts "      page_layout.param_values=#{page_layout.param_values.count}, section_params=#{section_params.count}"
        end        
        for sp in section_params
          if page_layout.param_values.select{|pv| pv.section_param_id==sp.id}.blank?
            incomplete_page_layouts << page_layout
            puts "      page_layout=#{page_layout.title},#{page_layout.id},section_id=#{sp.section_id}, missing section_param=#{sp.id}"            
          end
        end          
      else
        puts "error:page_layout=#{page_layout.id} has no section"
      end
    end 
    
    if ENV['FIX'].present?
      incomplete_page_layouts.uniq.each{| pl |
        pl.replace_with( Spree::Section.find( pl.section_id ))
      }
    end
    
    pvs = theme.param_values.all(:include=>{:section_param=>{:section_piece_param=>:param_category}})
    for pv in pvs
      if pv.section_param.blank?
        puts "error:pv=#{pv.id} has no section_param"  
      else
        if pv.section_param.section_piece_param.blank?
          puts "error:pv=#{pv.id} has no section_piece_param"  
        else
          if pv.section_param.section_piece_param.param_category.blank?
            puts "error:pv=#{pv.id},spp=#{pv.section_param.section_piece_param.id} has no param_category"
          end
        end
      end      
    end
  end
end

