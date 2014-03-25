namespace :spree_abc do
  desc "export application.root/db/mmddyyyy.sql !"
  task :export_full_sql => :environment do
    file_path = "#{Rails.root}/db/full_sql/#{Time.now.strftime("%Y%m%d")}.sql"
    db_config = ActiveRecord::Base.configurations[Rails.env]
    mysqldump = "mysqldump -n -t -R --dump_date -u #{db_config['username']} --password='#{db_config['password']}' -h '#{db_config['host']}' #{db_config['database']}"
    puts "db_config=#{db_config.inspect}"
    #exclude schema_imgrations, it is filled by rails.
    puts "#{mysqldump} --ignore-table=#{db_config['database']}.schema_migrations > #{file_path}"
    `#{mysqldump} --ignore-table=#{db_config['database']}.schema_migrations > #{file_path}`
  end
  
end