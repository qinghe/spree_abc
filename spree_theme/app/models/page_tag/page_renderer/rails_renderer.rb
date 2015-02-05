module PageTag::PageRenderer
  class RailsRenderer < Base
        
    def initialize( ehtml, ecss, ejs, context, controller)
      self.ehtml, self.ecss, self.ejs = ehtml, ecss, ejs
      self.context = context
      self.renderer = controller
      #ApplicationController.view_context_class.new, has no method render_to_string
      #refer to http://stackoverflow.com/questions/3369320/including-helpers-when-rendering-a-template-partial-by-hand
      #renderer.extend Spree::BaseHelper
    end
    
    def generate
      prepare_instance_variables
      self.html = renderer.render_to_string(:inline =>ehtml)
      return self.html
    end
  
    #generate css and js, they are do not need current menu
    def generate_assets
      prepare_instance_variables
      self.css = renderer.render_to_string(:inline =>ecss) if ecss.present?
      self.js = renderer.render_to_string(:inline =>ejs) if ejs.present?
      return self.css, self.js
    end
        
    private 
    def prepare_instance_variables
      self.context.each_pair{|key,val|
        self.renderer.instance_variable_set( "@#{key}", val)
      }      
    end
    
  end
end