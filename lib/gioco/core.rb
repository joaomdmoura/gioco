class Gioco
  class Core
    def self.get_resource(rid)
      RESOURCE_NAME.capitalize.constantize.find(rid)
    end

    def self.sync_resource_by_points(resource, points, type = false)

      badges = { :added => [], :removed =>[] }
      if TYPES && type
        old_pontuation  = resource.points.where(:type_id => type.id).sum(:value)
        related_badges  = Badge.where(((old_pontuation < points) ? "points <= #{points}" : "points > #{points} AND points <= #{old_pontuation}") + " AND type_id = #{type.id}")
      else
        old_pontuation  = resource.points.to_i
        related_badges  = Badge.where((old_pontuation < points) ? "points <= #{points}" : "points > #{points} AND points <= #{old_pontuation}")
      end
      
      new_pontuation    = ( old_pontuation < points ) ? points - old_pontuation : - (old_pontuation - points)

      Badge.transaction do
        if TYPES && type
          resource.points << Point.create({ :type_id => type.id, :value => new_pontuation })
        elsif POINTS
          resource.update_attribute( :points, points )
        end
        related_badges.each do |badge|
          if old_pontuation < points
            if !resource.badges.include?(badge)
              resource.badges << badge
              badges[:added] << badge
            end
          elsif old_pontuation > points
            resource.levels.where( :badge_id => badge.id )[0].destroy
            badges[:removed] << badge
          end
        end
        badges
      end
    end
    
  end
end