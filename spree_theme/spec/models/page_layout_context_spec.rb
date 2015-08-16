require 'spec_helper'
describe Spree::PageLayout do
  let (:page_layout) { Spree::PageLayout.first }


  it "valid section context" do

    product_detail = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.detail)
    product_detail.context_detail?.should be_true
    product_list = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.list)
    product_list.context_list?.should be_true
  end

  it "could update context" do
    list_section = Spree::PageLayout.find_by_section_context('list')
    detail_section = Spree::PageLayout.find_by_section_context('detail')
    #contexts = [Spree::PageLayout::ContextEnum.account, Spree::PageLayout::ContextEnum.thanks,Spree::PageLayout::ContextEnum.cart, Spree::PageLayout::ContextEnum.checkout]
    contexts = [Spree::PageLayout::ContextEnum.list, Spree::PageLayout::ContextEnum.detail]
    page_layout.update_section_context contexts

    for node in page_layout.self_and_descendants
      if node.is_or_is_descendant_of? list_section
        node.current_contexts.should eq(list_section.current_contexts)
      elsif   node.is_or_is_descendant_of? detail_section
        node.current_contexts.should eq(detail_section.current_contexts)
      else
        node.current_contexts.should eq(contexts)
      end
    end
  end

  it "could verify contexts" do
    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.cart, [:cart, :checkout, :thankyou ] ).should be_true

    Spree::PageLayout.verify_contexts( [Spree::PageLayout::ContextEnum.cart], [:cart, :checkout, :thankyou ] ).should be_true

    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.either, [:cart, :checkout, :thankyou ] ).should be_false
  end


  # page_layout tree
  # root
  #   product-list-grid( stylish=0 )
  #   product-list-line( stylish=1 )
  # taxon0(stylish=0), taxon1( stylish=1)
  # taxon0.valid_context?(product-list-grid ) => true
  # taxon0.valid_context?(product-list-line ) => false
end
