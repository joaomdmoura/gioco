module Gioco
  class Core
    def self.get_resource(rid)
      eval(RESOURCE_NAME.capitalize).find(rid)
    end

    def self.get_badge(bid)
      Badge.find(bid)
    end

    def self.ranking
      if POINTS
        eval(RESOURCE_NAME.capitalize).order("points DESC")
      else
        eval(RESOURCE_NAME.capitalize).all(
          :select => "#{eval(RESOURCE_NAME.capitalize).table_name}.*,
                      COUNT(levels.badge_id) AS number_of_levels",
          :joins => :levels,
          :group => "#{RESOURCE_NAME}_id",
          :order => "number_of_levels DESC")
      end
    end

    def self.sync_resource_by_points(resource, points)
      old_pontuation  = resource.points.to_i

      related_badges  = Badge.where((old_pontuation < points) ? "points <= #{points}" : "points > #{points} AND points <= #{old_pontuation}" )
      Badge.transaction do
        resource.update_attribute( :points, points )
        related_badges.each do |badge|
          if old_pontuation < points
            resource.badges << badge if !resource.badges.include?(badge)
          elsif old_pontuation > points
            resource.levels.where( :badge_id => badge.id )[0].destroy
          end
        end
      end
    end
  end
end