module PageTag
  #get attributes from current datasource
  class ModelAttribute

    attr_accessor :wrapped_model,:current_piece, :options
    attr_accessor :helpers
    delegate :tag, :image_tag, :content_tag, :to=> :helpers


    def initialize( current_piece, wrapped_model,  options = {})
      self.wrapped_model = wrapped_model
      self.current_piece = current_piece
      self.options = options
      self.helpers =  ActionController::Base.helpers
    end


    def get( attribute_name )
      raise "please implement ModelAttribute.get"
    end


    def pretty_datetime(time)
      [I18n.l(time.to_date, format: :long), time.strftime("%l:%M %p")].join(" ")
    end

    def pretty_date(time)
      I18n.l(time.to_date, format: :long)
    end

  end
end
