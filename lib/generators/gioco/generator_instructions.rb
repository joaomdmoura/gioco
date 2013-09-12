# encoding: utf-8
module GeneratorInstructions
	def instructions
		puts <<-EOS

=======================================================

Gioco successfully installed.

Now you are able to add Badges using:
  rake gioco:add_badge[BADGE_NAME#{",POINTS" if options[:points]}#{",KIND_NAME" if options[:kinds]},DEFAULT]

To remove Badges using:
  rake gioco:remove_badge[BADGE_NAME#{",KIND_NAME" if options[:kinds]}]

#{
  if options[:kinds]
"And to remove Kinds using:
  rake gioco:remove_kind[KIND_NAME]"
  end
}

For usage and more infomation go to the documentation:
http://joaomdmoura.github.com/gioco/

By João Moura (a.k.a joaomdmoura)

=======================================================

		EOS
	end
end