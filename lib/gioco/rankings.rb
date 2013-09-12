class Gioco
  class Ranking < Core

    def self.with_kind_and_points
      ranking = []
      Kind.all.each do |t|
        data = RESOURCE_NAME.capitalize.constantize
                .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*, 
                         points.kind_id, SUM(points.value) AS kind_points")
                .where("points.kind_id = #{t.id}")
                .joins(:points)
                .group("kind_id, #{RESOURCE_NAME}_id")
                .order("kind_points DESC")

        ranking << { :kind => t, :ranking => data }
      end
      ranking
    end

    def self.without_kind_and_points
      ranking = RESOURCE_NAME.capitalize.constantize
                  .select("#{RESOURCE_NAME.capitalize.constantize.table_name}.*,
                           COUNT(levels.badge_id) AS number_of_levels")
                  .joins(:levels)
                  .group("#{RESOURCE_NAME}_id")
                  .order("number_of_levels DESC")
    end

    def self.generate
      ranking = []
      if POINTS && KINDS
        ranking = self.with_kind_and_points
      elsif POINTS && !KINDS
        ranking = RESOURCE_NAME.capitalize.constantize.order("points DESC")
      elsif !POINTS && !KINDS
        ranking = without_kind_and_points
      end
      ranking
    end
  end
end
