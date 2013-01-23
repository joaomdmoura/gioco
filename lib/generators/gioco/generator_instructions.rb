# encoding: utf-8
module GeneratorInstructions
	def instructions
		puts <<-EOS

=======================================================

Gioco successfully installed.

Now you are able to add Badges using:
  rake gioco:add_badge[BADGE_NAME#{",POINTS" if options[:points]}#{",TYPE_NAME" if options[:types]},DEFAULT]

To remove Badges using:
  rake gioco:remove_badge[BADGE_NAME#{",TYPE_NAME" if options[:types]}]

#{
  if options[:types]
"And to remove Types using:
  rake gioco:remove_type[TYPE_NAME]"
  end
}

For usage and more infomation go to the documentation:
http://joaomdmoura.github.com/gioco/

By João Moura (a.k.a joaomdmoura)

=======================================================

		EOS
	end
end