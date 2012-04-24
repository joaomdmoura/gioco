module Gioco

	class SetupGenerator < Rails::Generators::NamedBase
		source_root File.expand_path("../../templates", __FILE__)
		
		desc "Setup Gioco for some resource"
		class_option :points, :type => :boolean, :default => false, :desc => "Setup gioco with points-system based"

		def generate_models
			generate("model", "badge name:string #{(options[:points]) ? "points:integer" : ""} default:boolean")
			generate("model", "level badge_id:integer #{file_name}_id:integer")
			generate("migration", "add_points_to_#{file_name.pluralize} points:integer") if options[:points]
		end

		def creating_templates
			@points = ( options[:points] ) ? true : false
			template "gioco.rb", "config/initializers/gioco.rb"
		end

		def setup_relations
			add_relationship( "badge", "levels", "has_many", false, "destroy" )
			add_relationship( "badge", file_name.pluralize, "has_many", "levels" )
			
			add_relationship( file_name, "levels", "has_many" )
			add_relationship( file_name, "badges", "has_many", "levels" )

			add_relationship( "level", file_name, "belongs_to" )
			add_relationship( "level", "badge", "belongs_to" )
		end

		def create_rakes
			rakefile("gioco.rake") do
				<<-EOS
# -*- encoding: utf-8 -*-
namespace :gioco do
	
	desc "Used to add a new badge at Gioco scheme"
	
	task :add_badge, [:name, #{(options[:points]) ? ":points, " : ""}:default] => :environment do |t, args|
		args.default = ( args.default ) ? eval(args.default) : false

		if !args.name #{(options[:points]) ? "&& !args.points" : ""}
			puts "There are missing some arguments"
		
		else
			badge = Badge.create({ 
														:name => args.name, 
														#{(options[:points]) ? ":points => args.points," : ""}
														:default => args.default
													})
			
			if args.default
				resources = #{file_name.capitalize}.find(:all)
				resources.each do |r|
					r.badges << badge
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
	rake gioco:add_badge[BADGE_NAME,POINTS,DEFAULT]

If you installed gioco without points option:
	rake gioco:add_badge[BADGE_NAME,DEFAULT]

And to remove Badges using:
	rake gioco:remove_badge[BADGE_NAME]

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