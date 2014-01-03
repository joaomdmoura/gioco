# Configure Rails Envinronmnt
require 'coveralls'
Coveralls.wear!

require 'rake'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
Rails.backtrace_cleaner.remove_silencers!