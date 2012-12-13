#!/usr/bin/env rake
require 'rubygems'
require 'rspec/core/rake_task'

desc "Run specs"
task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = ['./spec/**/*_spec.rb', './spec/**/*_fac.rb']
end

desc 'Generates a dummy app for testing'
task :dummy => [
                    :removing_app,
                    :generating_app,
                    :support_files,
                    :setup,
                    :cleanning_project,
                    :adding_badges
                  ]

test   = File.expand_path('../spec/dummy', __FILE__)
config = File.expand_path('../spec/support/config', __FILE__)

task :removing_app do
  sh "rm -rf #{test}"
end

task :generating_app do
  sh "rails new #{test} -q -f -G -S -J -T --skip-bundle --skip-gemfile"
end

task :support_files do
  sh "cp #{config}/* #{test}/config"
end

task :setup do
  sh "cd #{test};RAILS_ENV=test rails g model user name:string email:string"
  sh "cd #{test};RAILS_ENV=test rails g gioco:setup user --points --types"
end

task :cleanning_project do
  sh "rm -rf #{test}/spec"
  sh "rm -rf #{test}/doc"
  sh "rm -rf #{test}/README.rdoc"
  sh "rm -rf #{test}/tmp"
  sh "rm -rf #{test}/vendor"
  sh "rm -rf #{test}/public"
end

task :adding_badges do
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[noob,100,comments]"
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[medium,500,comments]"
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[hard,1000,comments]"
end

