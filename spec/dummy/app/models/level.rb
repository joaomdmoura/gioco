class Level < ActiveRecord::Base
      belongs_to :badge  
      belongs_to :user  
  attr_accessible :badge_id, :user_id
end
