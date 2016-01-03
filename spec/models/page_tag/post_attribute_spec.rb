require 'rails_helper'

describe PageTag::PostAttribute do

  before do
    Spree::Site.current = create(:site1)
    @post = create( :post )
  end

  let(:current_piece) {
    o =  PageTag::TemplateTag::WrappedPageLayout.new( nil,nil,0 )
    allow(o).to receive(:clickable?) { true }
    o
  }

  context "with post file " do
    let(:image) { File.open(File.expand_path('../../../fixtures/qinghe.jpg', __FILE__)) }
    let(:params) { {:viewable_id => @post.id, :viewable_type => 'Spree::Post', :attachment => image, :alt => "position 1", :position => 1} }
    let(:wrapped_post) { PageTag::Posts::WrappedPost.new( nil, @post) }

    before do
      Spree::PostFile.create(params)
      @post_attribute = PageTag::PostAttribute.new( current_piece, wrapped_post)
    end


    it "get file name" do
      allow( @post_attribute.wrapped_post ).to receive(:path) { '/' }
      #<a href="/shops/test/0/spree/post_files/1/qinghe_original.jpg?1444725622" title="qinghe.jpg">this is a post</a>
      @post_attribute.get( :file ).should =~/qinghe.jpg/
    end
  end

end
