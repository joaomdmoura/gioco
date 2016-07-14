##
# GiocoGenerator is the generator class responsible for declaring and implementing
# Rails generators user use when setting up gioco.

require "generators/helpers/model_generator_helper"

class GiocoGenerator < Rails::Generators::Base
  include ModelGeneratorHelper

  desc "Setup gioco for a specific model"
  argument :model, type: :string

  class_option :badges, aliases: :b, type: :boolean, default: false, desc: "Setup a badges architecture"

  # Main generator method responsible for gioco's setup
  def execute
    setup_models(options)
  end
end
