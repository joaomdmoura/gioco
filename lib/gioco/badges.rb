module Gioco
  class Badges < Core
    def self.add(rid, badge_id)
      resource        = get_resource( rid )
      badge           = Badge.find( badge_id )

      if POINTS && !resource.badges.include?(badge)
        if TYPES
          sync_resource_by_points( resource, badge.points, badge.type)
        else
          sync_resource_by_points( resource, badge.points)
        end
      elsif !resource.badges.include?(badge)
        resource.badges << badge
      end
    end

    def self.remove( rid, badge_id )
      resource  = get_resource( rid )
      badge     = Badge.find( badge_id )
      type      = badge.type

      if POINTS && resource.badges.include?(badge)
        if TYPES
          badges_gap = Badge.where( "points < #{badge.points} AND type_id = #{type.id}" )[0]
          sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points, type)
        else
          badges_gap = Badge.where( "points < #{badge.points}" )[0]
          sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points)
        end
      elsif resource.badges.include?(badge)
        resource.levels.where( :badge_id => badge.id )[0].destroy
      end
    end
  end
end