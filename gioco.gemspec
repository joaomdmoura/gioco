Gem::Specification.new do |s|

  s.name        = 'gioco'
  s.version     = File.read(File.dirname(__FILE__) + '/VERSION').strip
  s.date        = '2013-09-13'
  s.summary     = "A gamification gem for Ruby on Rails applications."
  s.description = "Gioco is a gem to easly implement gamification."
  s.authors     = ["João Moura"]
  s.email       = 'joaomdmoura@gmail.com'
  s.files       = Dir[ 'lib/*', 'lib/**/*', 'lib/**/**/*' ]
  s.homepage    = 'http://joaomdmoura.github.com/gioco/'

end
