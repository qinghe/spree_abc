namespace :spree_theme do
  desc "load themes"
  task :load_themes  => :environment do
    Rake::Task["spree_sample:load"].invoke    
    load File.join(SpreeTheme::Engine.root,'db/themes/seed.rb')
  end
  
  desc "reload section_piece.yml"
  task :reload_section_piece => :environment do    
    load File.join(SpreeTheme::Engine.root,'db/seeds/00_section_pieces.rb')
    Spree::TemplateTheme.all.each{|theme|
      Rake::Task['spree_theme:release_theme'].invoke(theme.id)  
    }    
  end
  
  desc "export theme. params: SITE_ID, THEME_ID, SEED_PATH."
  task :export_theme => :environment do
    if ENV['SITE_ID']
      theme = SpreeTheme.site_class.find( ENV['SITE_ID'] ).template_themes.first 
    elsif ENV['THEME_ID']
      theme = Spree::TemplateTheme.find ENV['THEME_ID'] 
    else
      theme = Spree::TemplateTheme.first        
    end
    serializable_data = theme.serializable_data
    #add site_id into name is required, later we want to import, just specify site_id is OK.
    if ENV['SEED_PATH']
      file_path = File.join(SpreeTheme::Engine.root,'db','themes','designs', "#{theme.site_id}_#{theme.id}_#{Time.now.to_i}.yml")
    else
      file_path =  File.join(theme.site.document_path, "#{theme.site_id}_#{theme.id}_#{Time.now.to_i}.yml")
    end
    open(file_path,'w') do |file|      
      file.write(serializable_data.to_yaml)
    end
    puts "exported file #{file_path}"
  end
  
  desc "import theme. params SEED_PATH, SITE_ID, THEME_ID." 
       "SEED_PATH='1' path = spree_theme/db/themes/designs/{site_id}_{theme_id}_{time}.yml"
       "default path=shops/rails_env/shop_id/{site_id}_{theme_id}_{time}.yml"
  task :import_theme => :environment do
    if ENV['SITE_ID']
      SpreeTheme.site_class.current = SpreeTheme.site_class.find ENV['SITE_ID']
    else
      SpreeTheme.site_class.current = SpreeTheme.site_class.designsite      
    end 
    
    theme_id = (ENV['THEME_ID'] || SpreeTheme.site_class.current.template_themes.first.id)
       
    if ENV['SEED_PATH']
      file_path = File.join(SpreeTheme::Engine.root,'db','themes','designs', "#{SpreeTheme.site_class.current.id}_#{theme_id}*.yml")
    else
      file_path = File.join(SpreeTheme.site_class.current.document_path, "#{SpreeTheme.site_class.current.id}_#{theme_id}*.yml")
    end
    file_path = Dir[file_path].sort.last      
    open(file_path) do |file|
      theme = Spree::TemplateTheme.import_into_db(file)
      #Rake::Task['spree_theme:release_theme'].execute(theme.id)
      theme.release({},{:page_only=>true})
    end    
    puts "imported file #{file_path}"
  end
  
  desc "release theme without new template_release, rake spree_theme:release_theme[1]"
  task :release_theme, [:theme_id] =>[ :environment ] do |t, args|
    theme = Spree::TemplateTheme.find( args.theme_id)
    theme.release({},{:page_only=>true})
  end  

  desc "get css of theme one, rake spree_theme:get_css[1,2,'block']"
  task :get_css, [:page_layout_id,:section_id, :class_name] =>[ :environment ] do |t, args|
    #theme = Spree::TemplateTheme.first
    class_name = args.class_name
    lg = PageGenerator.generator( DefaultTaxon.instance, SpreeTheme.site_class.designsite.template_theme)
    template = lg.context[:template]
    template.select(args.page_layout_id.to_i, args.section_id.to_i)
    puts "template 1, page_layout_id=#{args.page_layout_id}_#{args.section_id}, #{class_name}= #{template.css(class_name)}"
  end
  
  desc "test theme"
  task :test_theme =>[ :environment ] do |t, args|
    #section_pieces = Spree::SectionPiece.all(:include=>:section_piece_params)    
    #sections =  Spree::Section.all(:include=>{:section_params=>:section_piece_params})
    #page_layouts = Spree::PageLayout.all(:include=>{:section_params=>:section_piece_params})    
    if ENV['SITE_ID']
      theme = SpreeTheme.site_class.find( ENV['SITE_ID'] ).template_themes.first 
    else
      theme = Spree::TemplateTheme.first        
    end    
    incomplete_page_layouts = []
    # section_param and param_value match each other.
    for page_layout in theme.page_layout.self_and_descendants.includes(:section)     
      if page_layout.section.present?
        section_nodes = page_layout.section.self_and_descendants.includes(:section_params)
        section_params = section_nodes.collect(&:section_params).flatten
        if page_layout.param_values.where(:theme_id=>theme.id).count!=section_params.count
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
  
  
  def exported_theme_file_name( theme )
    "#{theme.site_id}_#{template.id}_#{Time.now.to_i}.yml"
  end 
end

