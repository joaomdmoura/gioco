module RakesGenerator
  def create_rakes
  rakefile 'gioco.rake' do
        <<-EOS
# -*- encoding: utf-8 -*-
namespace :gioco do

  desc "Used to add a new badge at Gioco scheme"

  task :add_badge, [:name, #{":points, " if options[:points]}#{":kind, " if options[:kinds]}:default] => :environment do |t, args|
    arg_default = ( args.default ) ? eval(args.default) : false


    if !args.name #{"|| !args.points" if options[:points]}#{" || !args.kind" if options[:kinds]}
      raise "There are missing some arguments"
    else
      badge_string = "#{options[:kinds] ? 'kind = Kind.find_or_create_by(name: \'#{args.kind}\')\n' : ''}"

      badge_string = badge_string + "badge = Badge.where 'name = ? AND kind_id = ?', '#\{args.name\}', #{"kind.id" if options[:kinds]}\n
                    if badge.empty?
                      badge = Badge.create({
                        name: \'\#\{args.name\}\',
                        #{"points: \'\#\{args.points\}\'," if options[:points]}
                        #{"kind_id: kind.id," if options[:kinds]}
                        default: \'\#\{arg_default\}\'
                      })
                    else
                      raise 'There is another badge with this name related with this kind'
                    end\n"

      if arg_default
        badge_string = badge_string + 'resources = #{@model_name.capitalize}.all\n'
        badge_string = badge_string + "resources.each do |r|
        #{
        if options[:points] && options[:kinds]
            "r.points  << Point.create({ :kind_id => kind.id, :value => \'\#\{args.points\}\'})"
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

      file_path = "/db/gioco/create_badge_\#\{args.name\}#{"_\#\{args.kind\}" if options[:kinds]}.rb"
      File.open("\#\{Rails.root\}\#\{file_path\}", 'w') { |f| f.write badge_string }
      File.open("\#\{Rails.root\}/db/gioco/db.rb", 'a') { |f| f.write "require \\"\\#\\{Rails.root\\}\#\{file_path\}\\"\n" }

    end

  end

  desc "Used to remove an old badge at Gioco scheme"

  task :remove_badge, [:name#{", :kind" if options[:kinds]}] => :environment do |t, args|
    if !args.name#{" || !args.kind" if options[:kinds]}
      raise "There are missing some arguments"
    else
      badge_string = "#{"kind = Kind.find_by_name('\#\{args.kind\}')" if options[:kinds]}
      badge = Badge.where( :name => '\#\{args.name\}'#{", :kind_id => kind.id" if options[:kinds]} ).first
      badge.destroy\n"
    end

    badge_string = badge_string + "puts '> Badge successfully removed'"

    eval badge_string

    file_path = "/db/gioco/remove_badge_\#\{args.name\}.rb"
    File.open("\#\{Rails.root\}\#\{file_path\}", 'w') { |f| f.write badge_string }
    File.open("\#\{Rails.root\}/db/gioco/db.rb", 'a') { |f| f.write "require \\"\\#\\{Rails.root\\}\#\{file_path\}\\"\n" }
  end
#{
if options[:kinds]
  '
  desc "Removes a given kind"
  task :remove_kind, [:name] => :environment do |t, args|
    if !args.name
      raise "There are missing some arguments"
    else
      kind_string = "kind = Kind.find_by_name( \'#{args.name}\' )\n"
      kind_string = kind_string + "if kind.badges.empty?
        kind.destroy
      else
        raise \'Aborted! There are badges related with this kind.\'
      end\n"
    end
    kind_string = kind_string + "puts \'> Kind successfully removed\'"
    eval kind_string

    file_path = "/db/gioco/remove_kind_#{args.name}.rb"
    File.open("#{Rails.root}#{file_path}", "w") { |f| f.write kind_string }
    File.open("#{Rails.root}/db/gioco/db.rb", "a") { |f| f.write "require \\"\\#\\{Rails.root\\}#{file_path}\\"\n" }
  end
  '
end
}
  task :sync_database => :environment do
    content = File.read("#{Rails.root}/db/gioco/db.rb")
    eval content
  end
end
        EOS
      end
  end
end
