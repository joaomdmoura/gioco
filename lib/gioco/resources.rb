class Gioco
  class Resources < Core
    def self.change_points(rid, points, tid = false)
      resource          = get_resource(rid)
      type              = (tid) ? Type.find(tid) : false
      if TYPES && tid
        old_pontuation  = resource.points.where(:type_id => tid).sum(:value)
      else
        old_pontuation  = resource.points.to_i
      end
      new_pontuation    = old_pontuation + points
      sync_resource_by_points(resource, new_pontuation, type)
    end

    def self.next_badge?(rid, tid = false)
      resource          = get_resource(rid)
      type              = (tid) ? Type.find(tid) : false
      if TYPES && tid
        old_pontuation  = resource.points.where(:type_id => tid).sum(:value)
      else
        old_pontuation  = resource.points.to_i
      end
      next_badge      = Badge.where("points > #{old_pontuation}").order("points ASC").first
      if next_badge
        percentage      = old_pontuation*100/next_badge.points
        points          = next_badge.points - old_pontuation
        next_badge_info = { 
                            :badge      => next_badge,
                            :points     => points,
                            :percentage => percentage
                          }
      end
    end
  end
end