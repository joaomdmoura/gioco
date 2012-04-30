module Gioco

  class Core

    def self.get_resource( rid )
      eval(RESOURCE_NAME.capitalize).find( rid )
    end

    def self.get_badge( bid )
      Badge.find( bid )
    end

    def self.get_level( rid, bid )
      Level.where( "#{RESOURCE_NAME}_id = #{rid} AND badge_id = #{bid}" )[0]
    end

    def self.ranking

      if POINTS

        eval(RESOURCE_NAME.capitalize).order( "points DESC" )

      else

        eval(RESOURCE_NAME.capitalize).all(
          :select => "#{eval(RESOURCE_NAME.capitalize).table_name}.*, 
                      COUNT(levels.badge_id) AS number_of_levels",
          :joins => :levels,
          :group => "#{RESOURCE_NAME}_id",
          :order => "number_of_levels DESC")

      end

    end

  end

  class Resources < Core

    def self.change_points( rid, points, resource = false )
      resource        = get_resource( rid ) if !resource
      new_pontuation  = resource.points.to_i + points
      old_pontuation  = resource.points.to_i
      status          = nil

      resource.update_attributes( {:points => new_pontuation } )

      if old_pontuation < new_pontuation

        related_badges  = Badge.where( "points <= #{new_pontuation}" )

        related_badges.each do |badge|
          Badges.add( nil, nil, resource, badge )
        end
      
      else

        related_badges  = Badge.where( "points > #{new_pontuation} AND points <= #{old_pontuation}" )

        related_badges.each do |badge|
          Badges.remove( resource.id, badge.id )
        end

      end

    end

  end

  class Badges < Core

    def self.add( rid, badge_id, resource = false, badge = false )
      resource  = get_resource( rid ) if !resource
      badge     = get_badge( badge_id ) if !badge

      Resources.change_points( nil, badge.points, resource ) if POINTS && badge.points > resource.points.to_i
      resource.badges << badge if !resource.badges.include?(badge)
    end

    def self.remove( rid, badge_id, resource = false, badge = false )
      level = get_level( rid, badge_id )
      level.destroy
    end

  end

end