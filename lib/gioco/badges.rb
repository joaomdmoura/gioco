module Gioco
  class Badges < Core
    def self.add(rid, badge_id)
      resource        = get_resource( rid )
      badge           = Badge.find( badge_id )

      if POINTS && !resource.badges.include?(badge)
        sync_resource_by_points( resource, badge.points )
      elsif !resource.badges.include?(badge)
        resource.badges << badge
      end
    end

    def self.remove( rid, badge_id )
      resource  = get_resource( rid )
      badge     = Badge.find( badge_id )

      if POINTS && resource.badges.include?(badge)
        new_ponctuation = Badge.where( "points < #{badge.points}" )[0]
        sync_resource_by_points( resource, ( new_ponctuation.nil? ) ? 0 : new_ponctuation.points )

      elsif resource.badges.include?(badge)
        resource.levels.where( :badge_id => badge.id )[0].destroy
      end
    end
  end
end