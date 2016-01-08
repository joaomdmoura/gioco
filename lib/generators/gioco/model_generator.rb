module ModelGenerator
  def generate_models
    generate("model", "level badge_id:integer #{@model_name}_id:integer")
    if options[:kinds]
      generate("model", "point #{@model_name}_id:integer kind_id:integer value:integer")
      generate("model", "kind name:string")
      generate("model", "badge name:string kind_id:integer  #{(options[:points]) ? "points:integer" : ""} default:boolean")
    else
      generate("migration", "add_points_to_#{@model_name.pluralize} points:integer") if options[:points]
      generate("model", "badge name:string #{(options[:points]) ? "points:integer" : ""} default:boolean")
    end
  end

  def creating_templates
    @points = (options[:points] ) ? true : false
    @kinds = (options[:kinds] ) ? true : false
    template "gioco.rb", "config/initializers/gioco.rb"
  end

  def adding_methods
    resource = File.read find_in_source_paths("resource.rb")
    badge    = File.read find_in_source_paths("badge.rb")
    inject_into_class "app/models/#{@model_name}.rb", @model_name.capitalize, "\n#{resource}\n"
    inject_into_class "app/models/badge.rb", "Badge", "\n#{badge}\n"
  end

  def setup_relations
    add_relationship("badge", "levels", "has_many", false, "destroy")
    add_relationship("badge", @model_name.pluralize, "has_many", "levels")
    
    add_relationship(@model_name, "levels", "has_many")
    add_relationship(@model_name, "badges", "has_many", "levels")

    add_relationship("level", @model_name, "belongs_to")
    add_relationship("level", "badge", "belongs_to")

    if options[:kinds]
      add_relationship(@model_name, "points", "has_many")
      add_relationship("kind", "points", "has_many")
      add_relationship("kind", "badges", "has_many")
      add_relationship("badge", "kind", "belongs_to")
      add_relationship("point", @model_name, "belongs_to")
      add_relationship("point", "kind", "belongs_to")
    end
  end

  def add_validations
    add_validation("badge", "name", [["presence", "true"]])
    add_validation("kind", "name", [["uniqueness", "true"], ["presence", "true"]]) if options[:kinds]
  end

  private

  def add_relationship (model, related, relation, through = false, dependent = false)
    inject_into_class "app/models/#{model}.rb", model.capitalize, "#{relation} :#{related} #{(through) ? ", :through => :#{through}" : ""} #{(dependent) ? ", :dependent => :#{dependent}" : ""}\n"
  end

  def add_validation (model, field, validations = [])
    validations.each do |validation|
      inject_into_class "app/models/#{model}.rb", model.capitalize, "validates :#{field}, :#{validation[0]} => #{validation[1]}\n"
    end
  end
end
