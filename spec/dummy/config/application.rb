require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

Bundler.require
require "gioco"

module Dummy
  class Application < Rails::Application

    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_record.whitelist_attributes = true
    
  end
end
