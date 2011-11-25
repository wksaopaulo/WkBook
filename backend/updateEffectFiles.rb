#encoding utf-8
require 'fileutils'

dest_dir = 'public/uploads/template/effect_file'
Dir.entries(dest_dir).delete_if{|e| e == '.' or e == '..'}.each do |d|
    Dir.entries(File.join dest_dir, d).each do |f|
      FileUtils.cp "../filters/public/#{f}", File.join(dest_dir, d, f) if f =~ /.*\.swf$/
      puts "../filters/public/#{f} ------> #{File.join(dest_dir, d, f)}" if f =~ /.*\.swf$/
    end if File.directory? File.join(dest_dir, d)
end
