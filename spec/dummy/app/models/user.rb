class User < ActiveRecord::Base
      has_many :badges , :through => :levels 
      has_many :levels  
  attr_accessible :email, :name
end
