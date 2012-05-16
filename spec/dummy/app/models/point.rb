class Point < ActiveRecord::Base
      belongs_to :type  
      belongs_to :user  
  attr_accessible :type_id, :user_id, :value
end
