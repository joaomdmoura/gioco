module RakesGenerator
  def create_rakes
  rakefile("gioco.rake") do
        <<-EOS
# -*- encoding: utf-8 -*-
namespace :gioco do
  
  desc "Used to add a new badge at Gioco scheme"
  
  task :add_badge, [:name, #{":points, " if options[:points]}#{":type, " if options[:types]}:default] => :environment do |t, args|
    arg_default = ( args.default ) ? eval(args.default) : false


    if !args.name #{"|| !args.points" if options[:points]}#{" || !args.type" if options[:types]}
      raise "There are missing some arguments"
    else
      badge_string = "#{options[:types] ? 'type = Type.find_or_create_by(name: \'#{args.type}\')\n' : ''}"

      badge_string = badge_string + "badge = Badge.create({ 
                      :name => \'\#\{args.name\}\', 
                      #{":points => \'\#\{args.points\}\'," if options[:points]}
                      #{":type_id  => type.id," if options[:types]}
                      :default => \'\#\{arg_default\}\'
                    })\n"

      if arg_default
        badge_string = badge_string + 'resources = #{@model_name.capitalize}.find(:all)\n'
        badge_string = badge_string + "resources.each do |r|
        #{
        if options[:points] && options[:types]
            "r.points  << Point.create({ :type_id => type.id, :value => \'\#\{args.points\}\'})"
        elsif options[:points]
          "r.points = \'\#\{args.points\}\'"
        end
        }
          r.badges << badge
          r.save!
        end\n"
      end
      
      badge_string = badge_string + "puts '> Badge successfully created'"

      eval badge_string
      
      file_path = "/db/gioco/create_badge_\#\{args.name\}#{"_\#\{args.type\}" if options[:types]}.rb"
      File.open("\#\{Rails.root\}\#\{file_path\}", 'w') { |f| f.write badge_string }
      File.open("\#\{Rails.root\}/db/gioco/db.rb", 'a') { |f| f.write "require \\"\\#\\{Rails.root\\}\#\{file_path\}\\"\n" }

    end

  end

  desc "Used to remove an old badge at Gioco scheme"

  task :remove_badge, [:name#{", :type" if options[:types]}] => :environment do |t, args|
    if !args.name#{" || !args.type" if options[:types]}
      raise "There are missing some arguments"
    else
      badge_string = "#{"type = Type.find_by_name('\#\{args.type\}')" if options[:types]}
      badge = Badge.where( :name => '\#\{args.name\}'#{", :type_id => type.id" if options[:types]} ).first
      badge.destroy\n"
    end

    badge_string = badge_string + "puts '> Badge successfully removed'"

    eval badge_string
    
    file_path = "/db/gioco/remove_badge_\#\{args.name\}.rb"
    File.open("\#\{Rails.root\}\#\{file_path\}", 'w') { |f| f.write badge_string }
    File.open("\#\{Rails.root\}/db/gioco/db.rb", 'a') { |f| f.write "require \\"\\#\\{Rails.root\\}\#\{file_path\}\\"\n" }
  end
#{
if options[:types]
  '
  desc "Removes a given type"
  task :remove_type, [:name] => :environment do |t, args|
    if !args.name
      raise "There are missing some arguments"
    else
      type_string = "type = Type.find_by_name( \'#{args.name}\' )\n"
      type_string = type_string + "if type.badges.empty?
        type.destroy
      else
        raise \'Aborted! There are badges related with this type.\'
      end\n"
    end
    type_string = type_string + "puts \'> Type successfully removed\'"
    eval type_string
    
    file_path = "/db/gioco/remove_type_#{args.name}.rb"
    File.open("#{Rails.root}#{file_path}", "w") { |f| f.write type_string }
    File.open("#{Rails.root}/db/gioco/db.rb", "a") { |f| f.write "require \\"\\#\\{Rails.root\\}#{file_path}\\"\n" }
  end
  '
end
}  
end
        EOS
      end     
  end
end