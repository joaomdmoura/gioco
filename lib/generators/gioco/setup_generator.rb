require "generators/gioco/model_generator"
require "generators/gioco/rakes_generator"
require "generators/gioco/migrations_generator"
require "generators/gioco/generator_instructions"

class Gioco
  class SetupGenerator < Rails::Generators::Base
    include ModelGenerator
    include RakesGenerator
    include MigrationsGenerator
    include GeneratorInstructions

    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Gioco for some resource"
    class_option :points, :kind => :boolean, :default => false, :desc => "Setup gioco with points-system based"
    class_option :kinds, :kind => :boolean, :default => false, :desc => "Setup gioco with multiples kinds(categories) of badges."


    def execute
      @model_name = ask("What is your resource model? (eg. user)")
      generate_models
      creating_templates
      adding_methods
      add_validations
      setup_relations
      create_rakes
      configuring_seed
      migrating
      instructions
    end
  
  end
end