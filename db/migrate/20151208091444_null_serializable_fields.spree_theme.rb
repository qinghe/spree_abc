class NullSerializableFields < ActiveRecord::Migration
  def change
    # default value should be nil or value translatable to hash, default '' would cause ActiveRecord::SerializationTypeMismatch on 4.2.2
    change_column :spree_template_themes, :assigned_resource_ids , :string, :limit => 2048, :null => true
  end
end
