module SpreeTheme
  class ClientInfo
    attr_accessor :is_mobile, :is_preview
    def initialize( attrs )
      self.is_mobile = !!attrs[:is_mobile]
      self.is_preview = !!attrs[:is_preview]
    end
  end
end