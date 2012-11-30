require "generators/gioco/model_generator"
require "generators/gioco/rakes_generator"
require "generators/gioco/migrations_generator"
require "generators/gioco/generator_instructions"

class Gioco
  class SetupGenerator < Rails::Generators::NamedBase
    include ModelGenerator
    include RakesGenerator
    include MigrationsGenerator
    include GeneratorInstructions

    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Gioco for some resource"
    class_option :points, :type => :boolean, :default => false, :desc => "Setup gioco with points-system based"
    class_option :types, :type => :boolean, :default => false, :desc => "Setup gioco with multiples types(categories) of badges."


    def execute
      generate_models
      creating_templates
      setup_relations
      create_rakes
      configuring_seed
      migrating
      instructions
    end
  
  end
end