class Badge < ActiveRecord::Base
      belongs_to :type  
      has_many :users , :through => :levels 
      has_many :levels  , :dependent => :destroy
  attr_accessible :default, :name, :points, :type_id
end
