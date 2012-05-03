Gem::Specification.new do |s|

  s.name        = 'gioco'
  s.version     = File.read(File.dirname(__FILE__) + '/VERSION').strip
  s.date        = '2012-04-25'
  s.summary     = "A gamification gem to Ruby on Rails applications."
  s.description = "Gioco is a easy to implement gamification gem based on plug and play concept.Doesn't matter if you already have a full and functional database, Gioco will smoothly integrateeverything and provide all methods that you might need."
  s.authors     = ["João Moura"]
  s.email       = 'joaomdmoura@gmail.com'
  s.files       = Dir[ 'lib/*', 'lib/**/*', 'lib/**/**/*', 'init.rb' ]
  s.homepage    = 'http://joaomdmoura.github.com/gioco/'
  s.has_rdoc 		= false
  s.test_files 	= Dir['test/**/*_test.rb']

  s.add_dependency	'rails', '>= 3.0.0'
  s.add_dependency	'activerecord', '>= 3.0.0'

end