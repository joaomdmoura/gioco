class Gioco
  class Resources < Core
    def self.change_points( rid, points, tid = false )
      resource          = get_resource( rid )
      type              = ( tid ) ? Type.find(tid) : false
      if TYPES && tid
        old_pontuation  = resource.points.where(:type_id => tid).sum(:value)
      else
        old_pontuation  = resource.points.to_i
      end
      new_pontuation    = old_pontuation + points
      sync_resource_by_points(resource, points, type)
    end
  end
end