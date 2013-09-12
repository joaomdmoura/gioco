class Gioco
  class Ranking < Core

    def self.ranking_with_type_and_points
      ranking = []
      Type.all.each do |t|
        data = RESOURCE_NAME.capitalize.constantize
                .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*, 
                         points.type_id, SUM(points.value) AS type_points")
                .where("points.type_id = #{t.id}")
                .joins(:points)
                .group("type_id, #{RESOURCE_NAME}_id")
                .order("type_points DESC")

        ranking << { :type => t, :ranking => data }
      end
      ranking
    end

    def self.ranking_without_type_and_points
      ranking = RESOURCE_NAME.capitalize.constantize
                  .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*,
                           COUNT(levels.badge_id) AS number_of_levels")
                  .joins(:levels)
                  .group("#{RESOURCE_NAME}_id")
                  .order("number_of_levels DESC")
    end

    def self.generate
      if POINTS && TYPES
        ranking = self.ranking_with_type_and_points
      elsif POINTS && !TYPES
        ranking = RESOURCE_NAME.capitalize.constantize.order("points DESC")
      elsif !POINTS && !TYPES
        ranking = ranking_without_type_and_points
      end
      ranking
    end
  end
end
