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


  desc "add page_layouts.image_param, fix content_param"
  task :fix_image_param  => :environment do
    section_id = 17
    page_layouts = Spree::PageLayout.where section_id: section_id

    page_layouts.each{ |pl|
      if pl.content_param>1
        # bit 2,3,4
        idx = (pl.get_content_param&14)>>1
        # default is medium
        #   000x , 001x,  010x,    011x,    100x
        size = [:medium, :large, :product, :small, :original ].fetch( idx, :medium )

        # bit 9,   10,  product-image
        #   256 + 512 = 768
        position = (pl.get_content_param&768)>>8

        puts "page_layout#{pl.id}-#{pl.title}=" +[size,position].inspect + pl.get_parsed_image_param.inspect

        pl.update_attribute :image_param, [size,position].join(',')

      end
    }

  end


end
