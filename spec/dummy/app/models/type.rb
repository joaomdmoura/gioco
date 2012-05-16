class Type < ActiveRecord::Base
      has_many :badges  
      has_many :points  
  attr_accessible :name
end
