module ModelGenerator
  def generate_models
    generate("model", "level badge_id:integer #{@model_name}_id:integer")
    if options[:types]
      generate("model", "point user_id:integer type_id:integer value:integer")
      generate("model", "type name:string") 
      generate("model", "badge name:string type_id:integer  #{(options[:points]) ? "points:integer" : ""} default:boolean")
    else
      generate("migration", "add_points_to_#{@model_name.pluralize} points:integer") if options[:points]
      generate("model", "badge name:string #{(options[:points]) ? "points:integer" : ""} default:boolean")
    end
  end

  def creating_templates
    @points = (options[:points] ) ? true : false
    @types = (options[:types] ) ? true : false
    template "gioco.rb", "config/initializers/gioco.rb"
  end

  def adding_methods
    contents = File.read('generators/templates/resource.rb')
    p contents
    p "================================================"
    add_method(@model_name, "lol")
  end

  def setup_relations
    add_relationship("badge", "levels", "has_many", false, "destroy")
    add_relationship("badge", @model_name.pluralize, "has_many", "levels")
    
    add_relationship(@model_name, "levels", "has_many")
    add_relationship(@model_name, "badges", "has_many", "levels")

    add_relationship("level", @model_name, "belongs_to")
    add_relationship("level", "badge", "belongs_to")

    if options[:types]
      add_relationship(@model_name, "points", "has_many")
      add_relationship("type", "points", "has_many")
      add_relationship("type", "badges", "has_many")
      add_relationship("badge", "type", "belongs_to")
      add_relationship("point", @model_name, "belongs_to")
      add_relationship("point", "type", "belongs_to")
    end
  end

  def add_validations
    add_validation("badge", "name", [["presence", "true"]])
    add_validation("type", "name", [["uniqueness", "true"], ["presence", "true"]]) if options[:types]
  end

  private

    def add_relationship (model, related, relation, through = false, dependent = false)
      gsub_file "app/models/#{model}.rb", get_class_header(model), "#{get_class_header(model)}
      #{relation} :#{related} #{(through) ? ", :through => :#{through}" : ""} #{(dependent) ? ", :dependent => :#{dependent}" : ""}"
    end

    def add_validation (model, field, validations = [])
      validations.each do |validation|
        gsub_file "app/models/#{model}.rb", get_class_header(model), "#{get_class_header(model)}
        validates :#{field}, :#{validation[0]} => #{validation[1]}"
      end
    end

    def add_method (model, method)
      gsub_file "app/models/#{model}.rb", get_class_header(model), "#{get_class_header(model)}
      #{method}"
    end

    def get_class_header (model_name)
      "class #{model_name.capitalize} < ActiveRecord::Base"
    end
end