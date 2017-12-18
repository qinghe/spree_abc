namespace :spree_theme do
  desc "fix user_terminal, now it is required"
  task :fix_user_terminal_id  => :environment do
    themes = Spree::TemplateTheme.all
    themes.each{|theme|
      next if theme.current_template_release.blank?
      if theme.user_terminal.blank?
        terminal_enum = 'unknown'
        if theme.for_desktop?
          terminal_enum = 'desktop'
          theme.user_terminal = Spree::UserTerminal.pc.first
        elsif theme.for_mobile?
          terminal_enum = 'mobile'
          theme.user_terminal = Spree::UserTerminal.cellphone.first
        end
 puts "template theme (#{theme.id})#{theme.title} require user_terminal #{terminal_enum}"
        theme.save!
      end
    }
  end



  desc "fix theme copy from id"
  task :fix_copy_from_id  => :environment do
    themes = Spree::TemplateTheme.all
    themes.each{|theme|
      next if theme.current_template_release.blank?
      original = theme.page_layout_root.template_theme
      if theme != theme.page_layout_root.template_theme
 puts "template theme (#{theme.id})#{theme.title} has original (#{original.id})#{original.title}"
       theme.copy_from_id = original.id
       theme.save!
      end
    }
  end
end
