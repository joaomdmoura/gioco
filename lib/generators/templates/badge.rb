def add(resource_id)
  resource = Gioco::Core.get_resource(resource_id)

  if Gioco::Core::POINTS && !resource.badges.include?(self)
    if Gioco::Core::KINDS
      Gioco::Core.sync_resource_by_points(resource, self.points, self.kind)
    else
      Gioco::Core.sync_resource_by_points(resource, self.points)
    end
  elsif !resource.badges.include?(self)
    resource.badges << self
    return self
  end
end

def remove(resource_id)
  resource = Gioco::Core.get_resource(resource_id)

  if Gioco::Core::POINTS && resource.badges.include?(self)
    if Gioco::Core::KINDS
      kind       = self.kind
      badges_gap = Badge.where( "points < #{self.points} AND kind_id = #{kind.id}" ).order('points DESC')[0]
      Gioco::Core.sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points, kind)
    else
      badges_gap = Badge.where( "points < #{self.points}" ).order('points DESC')[0]
      Gioco::Core.sync_resource_by_points( resource, ( badges_gap.nil? ) ? 0 : badges_gap.points)
    end
  elsif resource.badges.include?(self)
    resource.levels.where( :badge_id => self.id )[0].destroy
    return self
  end
end