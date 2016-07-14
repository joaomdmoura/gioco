# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gioco/version"

Gem::Specification.new do |s|
  s.name        = "gioco"
  s.version     = Gioco::VERSION.dup
  s.date        = "2016-07-13"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "A gamification gem for Ruby on Rails applications."
  s.description = "Gioco is a gem to easly implement gamification."
  s.authors     = ["João Moura"]
  s.email       = "joaomdmoura@gmail.com"
  s.files       = Dir["lib"]
  s.homepage    = "https://github.com/joaomdmoura/gioco"
  s.licenses    = ["MIT"]
end
