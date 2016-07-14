##
# GiocoGenerator is the generator class responsible for declaring and implementing
# Rails generators user use when setting up gioco.

require "generators/helpers/model_generator_helper"

class GiocoGenerator < Rails::Generators::Base
  include ModelGeneratorHelper

  desc "Setup gioco for a specific model"
  argument :model, type: :string

  def execute
    setup_models
  end
end
