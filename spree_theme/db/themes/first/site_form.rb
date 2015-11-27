include SpreeTheme::SeedHelper
#
# root - site_form
#
#
template = Spree::TemplateTheme.create_plain_template( section_piece_hash['root2'], "TemplateSiteForm" )

site_form_section = template.add_section(section_hash['site-form'])
