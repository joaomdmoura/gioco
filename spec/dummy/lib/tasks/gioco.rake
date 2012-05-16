# -*- encoding: utf-8 -*-
namespace :gioco do
  
  desc "Used to add a new badge at Gioco scheme"
  
  task :add_badge, [:name, :points, :default, :type] => :environment do |t, args|
    args.default = ( args.default ) ? eval(args.default) : false


    if !args.name && !args.points && !args.type
      puts "There are missing some arguments"
    
    else
      type = ( Type.find_by_name(args.type) ) ? Type.find_by_name(args.type) : Type.create({ :name => args.type })

      badge = Badge.create({ 
                            :name => args.name, 
                            :points => args.points,
                            :type_id  => type.id,
                            :default => args.default
                          })

      if args.default
        resources = User.find(:all)
        resources.each do |r|
          r.points  << Point.create({ :type_id => type.id, :value => args.points })
          r.badges << badge
          r.save
        end
      end

    end

  end

  desc "Used to remove an old badge at Gioco scheme"

  task :remove_badge, [:name] => :environment do |t, args|

    if !args.name
      puts "There are missing some arguments"
    
    else
      badge = Badge.find_by_name( args.name )
      badge.destroy
    end

  end
task :remove_type, [:name] => :environment do |t, args|

      if !args.name
        puts "There are missing some arguments"
      
      else
        type = Type.find_by_name( args.name )
        
        if type.badges.nil?
          type.destroy
        else
          puts "Aborted! There are badges related with this type."
        end
      end
    end  
end
