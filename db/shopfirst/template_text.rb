# load file template_text.yml
# File.write('db/shopfirst/template_text.yml', Spree::TemplateText.all.to_yaml )
#
def load_template_text
  records = YAML.load_file(File.join(File.dirname(__FILE__),'template_text.yml'))
  records.each{|row|
    Spree::TemplateText.connection.insert_fixture(row.attributes, Spree::TemplateText.table_name)
  }
end
Spree::TemplateText.delete_all

load_template_text