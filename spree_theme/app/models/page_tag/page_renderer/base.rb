module PageTag::PageRenderer
  class Base  
    attr_accessor :html, :css, :js
    #ruby embeded source
    attr_accessor :ehtml, :ecss, :ejs 
    attr_accessor :context, :renderer
    
    def generate
      raise NotImplementedError
    end
  
    #generate css and js, they are do not need current menu
    def generate_assets
      raise NotImplementedError
    end
      
    def generate_from_erb_file
      raise NotImplementedError
    end

    def release
      raise NotImplementedError
    end
     
  end
end