module MigrationsGenerator
 def migrating
    puts <<-EOS

=======================================
> Running rake db:migrate
=======================================

    EOS
    rake("db:migrate")
  end

  def configuring_database
    empty_directory "db/gioco"
    create_file "db/gioco/db.rb"
  end
end