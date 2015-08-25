require 'spec_helper'
describe PageTag::PageGenerator do
  before (:each) {
    SpreeTheme.site_class.current = create(:fake_site)
    @template_theme = create(:published_template_theme)
    #@page_generator = PageTag::PageGenerator.previewer( DefaultTaxon.instance, @template_theme, :controller=>Spree::TemplateThemesController.new)
  }


  it "menu section should use default taxon in case no taxon assigned" do
    theme = @template_theme
#    page_layout = theme.page_layout.self_and_descendants.find(:first,:conditions=>["spree_section_pieces.resources like ?",'m%'],:include=>[:sections=>:section_piece])
#    menu_section = page_layout.sections.first
#    theme.unassign_resource( SpreeTheme.taxon_class, page_layout)
#    theme.assigned_resources( SpreeTheme.taxon_class, page_layout).compact.should be_blank

#    page_generator.theme.reload
#    page_generator.current_page_tag.template_tag.select( page_layout.id, menu_section.id)
#    menu = page_generator.current_page_tag.template_tag.menu
#    menu.should be_kind_of PageTag::Menus::WrappedMenu
#    menu.model.should be_kind_of DefaultTaxon
  end

  it "taxon should get resources" do



  end

end
