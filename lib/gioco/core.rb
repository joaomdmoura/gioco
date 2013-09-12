class Gioco
  class Core
    def self.get_resource(rid)
      RESOURCE_NAME.capitalize.constantize.find(rid)
    end

    def self.related_info(resource, points, kind)
      if KINDS && kind
        old_pontuation  = resource.points.where(:kind_id => kind.id).sum(:value)
        related_badges  = Badge.where(((old_pontuation < points) ? "points <= #{points}" : "points > #{points} AND points <= #{old_pontuation}") + " AND kind_id = #{kind.id}")
      else
        old_pontuation  = resource.points.to_i
        related_badges  = Badge.where((old_pontuation < points) ? "points <= #{points}" : "points > #{points} AND points <= #{old_pontuation}")
      end
      new_pontuation    = ( old_pontuation < points ) ? points - old_pontuation : - (old_pontuation - points)

      { old_pontuation: old_pontuation, related_badges: related_badges, new_pontuation: new_pontuation }
    end

    def self.sync_resource_by_points(resource, points, kind = false)

      badges         = {}
      info           = self.related_info(resource, points, kind)
      old_pontuation = info[:old_pontuation]
      related_badges = info[:related_badges]
      new_pontuation = info[:new_pontuation]

      Badge.transaction do
          if KINDS && kind
          resource.points << Point.create({ :kind_id => kind.id, :value => new_pontuation })
        elsif POINTS
          resource.update_attribute( :points, points )
        end
        related_badges.each do |badge|
          if old_pontuation < points
            unless resource.badges.include?(badge)
              resource.badges << badge
              badges[:added] = [] if badges[:added].nil?
              badges[:added] << badge
            end
          elsif old_pontuation > points
            resource.levels.where( :badge_id => badge.id )[0].destroy
            badges[:removed] = [] if badges[:removed].nil?
            badges[:removed] << badge
          end
        end
        badges
      end
    end
  end
end