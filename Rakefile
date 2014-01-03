#!/usr/bin/env rake
require 'rubygems'
require 'rspec/core/rake_task'

desc "Run specs"
task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = ['./spec/factories/*.rb', './spec/specs/*.rb', './spec/shared_contexts/*.rb']
end

desc 'Generates a full dummy app for testing'
task :dummy => [
                  :removing_app,
                  :generating_app,
                  :setup,
                  :cleanning_project,
                  :trash_badges,
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

task :setup do
  sh "cd #{test};RAILS_ENV=test rails g model user name:string email:string"
  sh "cd #{test};echo user | RAILS_ENV=test rails g gioco:setup --points --kinds;"
end

task :cleanning_project do
  sh "rm -rf #{test}/spec"
  sh "rm -rf #{test}/doc"
  sh "rm -rf #{test}/README.rdoc"
  sh "rm -rf #{test}/tmp"
  sh "rm -rf #{test}/vendor"
  sh "rm -rf #{test}/public"
end

task :trash_badges do
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[noob,100,teacher]"
  sh "cd #{test};RAILS_ENV=test rake gioco:remove_badge[noob,teacher]"
  sh "cd #{test};RAILS_ENV=test rake gioco:remove_kind[teacher]"
end

task :adding_badges do
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[noob,100,comments]"
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[medium,500,comments]"
  sh "cd #{test};RAILS_ENV=test rake gioco:add_badge[hard,1000,comments]"
end

