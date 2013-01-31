def change_points(options)
  if Gioco::Core::TYPES
    type_id = options[:type]
    points  = options[:points]
  else
    points  = options
  end
  type      = (type_id) ? Type.find(type_id) : false

  if Gioco::Core::TYPES
    raise "Missing Type Identifier argument" if !type_id
    old_pontuation  = self.points.where(:type_id => type_id).sum(:value)
  else
    old_pontuation  = self.points.to_i
  end
  new_pontuation    = old_pontuation + points
  Gioco::Core.sync_resource_by_points(self, new_pontuation, type)
end

def next_badge?(type_id = false)
  type              = (type_id) ? Type.find(type_id) : false
  if Gioco::Core::TYPES
    raise "Missing Type Identifier argument" if !type_id
    old_pontuation  = self.points.where(:type_id => type_id).sum(:value)
  else
    old_pontuation  = self.points.to_i
  end
  next_badge       = Badge.where("points > #{old_pontuation}").order("points ASC").first
  last_badge_point = self.badges.last.try('points')
  last_badge_point ||= 0

  if next_badge
    percentage      = (old_pontuation - last_badge_point)*100/(next_badge.points - last_badge_point)
    points          = next_badge.points - old_pontuation
    next_badge_info = { 
                        :badge      => next_badge,
                        :points     => points,
                        :percentage => percentage
                      }
  end
end