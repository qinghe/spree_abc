
default_path = File.join(SpreeMultiSite::Config.seed_dir, 'default')
# This first resets the task's already_invoked state, allowing the task to then be executed again, dependencies and all:
Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(default_path)

# For easy to test, load first shop while load seeds. 
default_path = File.join(SpreeMultiSite::Config.seed_dir, 'firstshop')
Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(default_path)