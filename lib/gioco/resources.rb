module Gioco
  class Resources < Core

    def self.change_points( rid, points, resource = false )

      resource        = get_resource( rid ) if !resource
      new_pontuation  = resource.points.to_i + points

      sync_resource_by_points( resource, new_pontuation )

    end

  end
end
