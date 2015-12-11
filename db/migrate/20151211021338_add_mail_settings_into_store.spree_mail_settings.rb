# This migration comes from spree_mail_settings (originally 20151010070030)
class AddMailSettingsIntoStore < ActiveRecord::Migration
  def change
    # Default smtp settings
    # :mail_host, :string, default: 'localhost'
    # :mail_domain, :string, default: 'localhost'
    # :mail_port, :integer, default: 25
    # :secure_connection_type, :string, default: Core::MailSettings::SECURE_CONNECTION_TYPES[0]
    # :mail_auth_type, :string, default: Core::MailSettings::MAIL_AUTH[0]
    # :smtp_username, :string
    # :smtp_password, :string
    add_column :spree_stores, :enable_mail_delivery, :boolean, default: false
    add_column :spree_stores, :mail_host, :string                # 'smtp.gmail.com'
    add_column :spree_stores, :mail_port, :integer, default: 25
    add_column :spree_stores, :secure_connection_type, :string, default: 'None'
    add_column :spree_stores, :mail_auth_type, :string, default: 'None'
    add_column :spree_stores, :mail_domain, :string              # 'example.com',
    add_column :spree_stores, :smtp_username, :string
    add_column :spree_stores, :smtp_encrypted_password, :string

  end

end
