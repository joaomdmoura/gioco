def add(resource_id)
  resource = Gioco::Core.get_resource(resource_id)
  badge    = self

  if Gioco::Core::POINTS && !resource.badges.include?(badge)
    if Gioco::Core::TYPES
      Gioco::Core.sync_resource_by_points(resource, badge.points, badge.type)
    else
      Gioco::Core.sync_resource_by_points(resource, badge.points)
    end
  elsif !resource.badges.include?(badge)
    resource.badges << badge
    return badge
  end
end

def remove(resource_id)
  resource = Gioco::Core.get_resource(resource_id)
  badge    = self

  if Gioco::Core::POINTS && resource.badges.include?(badge)
    if Gioco::Core::TYPES
      type       = badge.type
      badges_gap = Badge.where( "points < #{badge.points} AND type_id = #{type.id}" )[0]
      Gioco::Core.sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points, type)
    else
      badges_gap = Badge.where( "points < #{badge.points}" )[0]
      Gioco::Core.sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points)
    end
  elsif resource.badges.include?(badge)
    resource.levels.where( :badge_id => badge.id )[0].destroy
  end
end