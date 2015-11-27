Spree::Section.roots.each{|section|
  case section.title
    when /image with thumbnails/
      section.usage = 'image-with-thumbnails'
    when /image/
      section.usage = 'image'
    when /dialog/
      section.usage = 'dialog'
    when /container/
      section.usage = 'container'
    when /root/
      section.usage = 'root'
  end
  section.save!
}
