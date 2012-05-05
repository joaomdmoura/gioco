class Badge < ActiveRecord::Base
      has_many :users , :through => :levels 
      has_many :levels  , :dependent => :destroy
  attr_accessible :default, :name, :points
end
