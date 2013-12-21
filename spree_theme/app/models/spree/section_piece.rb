module Spree
  class SectionPiece < ActiveRecord::Base
    extend FriendlyId
    has_many  :sections
    has_many  :section_piece_params
    friendly_id :title, :use => :slugged
  end
end