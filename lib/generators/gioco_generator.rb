##
# GiocoGenerator is the generator class responsible for declaring and implementing
# Rails generators user use when setting up gioco.

class GiocoGenerator < Rails::Generators::Base

  desc "Setup gioco for a specific model"
  argument :model, type: :string

  def execute
  end
end
