##
# ModelGeneratorHelper is a helper that contains all method and logic related
# the the model generation and relationships definitions when running gioco generator.

module ModelGeneratorHelper

  # Responsible for creating the new models and adding relationships.
  #
  # ==== Attributes
  #
  # * +options+ - A Hash containing the generators options passed on GiocoGenerator
  #
  def setup_models(options)
    setup_badges if options[:badges]
  end

  private

  # Creates all badges related model, migrations and injections.
  def setup_badges
    generate("model", "badge name:string")
    generate("migration", "create_badges_and_#{model.pluralize} badge:references #{model}:references")
    add_relationship("badge", model.pluralize, "has_and_belongs_to_many")
    add_relationship(model, "badges", "has_and_belongs_to_many")
  end

  # Helper method for easly inject relationships into models classes.
  def add_relationship (model, related, relation)
    inject_into_class "app/models/#{model}.rb", model.capitalize, "#{relation} :#{related}\n"
  end
end
