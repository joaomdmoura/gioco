module MigrationsGenerator
 def migrating
    puts <<-EOS

=======================================
> Running rake db:migrate
=======================================

    EOS
    rake("db:migrate")
  end

  def configuring_seed
    empty_directory "db/gioco"
    create_file "db/gioco/db.rb"
    append_file 'db/seeds.rb', 'require "#{Rails.root}/db/gioco/db.rb"'
  end
end