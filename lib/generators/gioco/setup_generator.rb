module Gioco

  class SetupGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Gioco for some resource"
    class_option :points, :type => :boolean, :default => false, :desc => "Setup gioco with points-system based"
    class_option :types, :type => :boolean, :default => false, :desc => "Setup gioco with multiples types(categories) of badges."

    def generate_models
      generate("model", "level badge_id:integer #{file_name}_id:integer")
      if options[:types]
        generate("model", "point user_id:integer type_id:integer value:integer")
        generate("model", "type name:string") 
        generate("model", "badge name:string type_id:integer  #{(options[:points]) ? "points:integer" : ""} default:boolean")
      else
        generate("migration", "add_points_to_#{file_name.pluralize} points:integer") if options[:points]
        generate("model", "badge name:string #{(options[:points]) ? "points:integer" : ""} default:boolean")
      end
    end

    def creating_templates
      @points = ( options[:points] ) ? true : false
      @types = ( options[:types] ) ? true : false
      template "gioco.rb", "config/initializers/gioco.rb"
    end

    def setup_relations
      add_relationship( "badge", "levels", "has_many", false, "destroy" )
      add_relationship( "badge", file_name.pluralize, "has_many", "levels" )
      
      add_relationship( file_name, "levels", "has_many" )
      add_relationship( file_name, "badges", "has_many", "levels" )

      add_relationship( "level", file_name, "belongs_to" )
      add_relationship( "level", "badge", "belongs_to" )

      if options[:types]
        add_relationship( file_name, "points", "has_many" )
        add_relationship( "type", "points", "has_many" )
        add_relationship( "type", "badges", "has_many" )
        add_relationship( "badge", "type", "belongs_to" )
        add_relationship( "point", file_name, "belongs_to" )
        add_relationship( "point", "type", "belongs_to" )
      end
    end

    def create_rakes
      rakefile("gioco.rake") do
        <<-EOS
# -*- encoding: utf-8 -*-
namespace :gioco do
  
  desc "Used to add a new badge at Gioco scheme"
  
  task :add_badge, [:name, #{":points, " if options[:points]}:default#{", :type" if options[:types]}] => :environment do |t, args|
    args.default = ( args.default ) ? eval(args.default) : false


    if !args.name #{"&& !args.points" if options[:points]}#{" && !args.type" if options[:types]}
      puts "There are missing some arguments"
    
    else
      #{"type = ( Type.find_by_name(args.type) ) ? Type.find_by_name(args.type) : Type.create({ :name => args.type })" if options[:types]}

      badge = Badge.create({ 
                            :name => args.name, 
                            #{":points => args.points," if options[:points]}
                            #{":type_id  => type.id," if options[:types]}
                            :default => args.default
                          })

      if args.default
        resources = #{file_name.capitalize}.find(:all)
        resources.each do |r|
          #{
          if options[:points] && options[:types]
            "r.points  << Point.create({ :type_id => type.id, :value => args.points })"
          elsif options[:points]
            "r.points = args.points"
          end
          }
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
#{
  if options[:types]
    'task :remove_type, [:name] => :environment do |t, args|

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
    end'
  end
}  
end
        EOS
      end
    end

    def migrating
      puts <<-EOS

=======================================
> Now is time to run rake db:migrate
=======================================

      EOS
      rake("db:migrate")
    end

    def instructions
      puts <<-EOS

=======================================================

Gioco successfully installed.

Now you are able to add Badges using:
  rake gioco:add_badge[BADGE_NAME#{",POINTS" if options[:points]}#{",TYPE" if options[:types]},DEFAULT]

To remove Badges using:
  rake gioco:remove_badge[BADGE_NAME]

#{
  if options[:types]
"And to remove Types using:
  rake gioco:remove_type[TYPE_NAME]"
  end
}

For usage and more infomation go to the documentation:
http://joaomdmoura.github.com/gioco/

=======================================================

      EOS
    end
    
    private

    def add_relationship ( model, related, relation, through = false, dependent = false )
      gsub_file "app/models/#{model}.rb", get_class_header(model), "#{get_class_header(model)}
      #{relation} :#{related} #{(through) ? ", :through => :#{through}" : ""} #{(dependent) ? ", :dependent => :#{dependent}" : ""}"
    end

    def get_class_header ( model_name )
      "class #{model_name.capitalize} < ActiveRecord::Base"
    end

  end

end