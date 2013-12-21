module PageRenderer
  class ErubisRenderer < Base
    cattr_accessor :pattern
    self.pattern = '<\% \%>'
    
    def initialize( ehtml, ecss, ejs, context)
      self.ehtml, self.ecss, self.ejs = ehtml, ecss, ejs
      self.context = context
    end
    
    def generate
      html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
      self.html = html_eruby.evaluate(context)  
      return self.html
    end
  
    #generate css and js, they are do not need current menu
    def generate_assets
      css_eruby = Erubis::Eruby.new(self.ecss,:pattern=>self.class.pattern)
      self.css = css_eruby.evaluate(context)
      return self.css, self.js
    end
      
    def generate_from_erb_file()
      #path = File.join(self.class.layout_base_path, self.theme.file_name('ehtml'))
      #erb_html =  open(path) do |f|  f.read end
      
      #self.ehtml = erb_html
      #html_eruby = Erubis::Eruby.new(self.ehtml,:pattern=>self.class.pattern)
      #self.html = html_eruby.evaluate(context) 
      
      #return self.html, self.css
    end    
  end
end