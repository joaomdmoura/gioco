module Gioco

	class Core

		def self.get_resource( rid )
			eval(Gioco::Resources::NAME.capitalize).find( rid )
		end

		def self.get_badge( bid )
			Badge.find( bid )
		end

		def self.get_level( rid, bid )
			Level.where( "#{Gioco::Resources::NAME}_id = #{rid} AND badge_id = #{bid}" )[0]
		end

	end

	class Resources < Core

		def self.change_points( rid, points, resource = false )
			resource 				= get_resource( rid ) if !resource
			new_pontuation 	= resource.points.to_i + points
			old_pontuation 	= resource.points.to_i
			status					= nil

			resource.update_attributes( {:points => new_pontuation } )

			if old_pontuation < new_pontuation

				related_badges 	= Badge.where( "points <= #{new_pontuation}" )

				related_badges.each do |badge|
					Badges.add( nil, nil, resource, badge )
				end
			
			else

				related_badges 	= Badge.where( "points > #{new_pontuation} AND points <= #{old_pontuation}" )

				related_badges.each do |badge|
					Badges.remove( resource.id, badge.id )
				end

			end

		end

	end

	class Badges < Core

		def self.add( rid, badge_id, resource = false, badge = false )
			resource 	= get_resource( rid ) if !resource
			badge 		= get_badge( badge_id ) if !badge

			resource.badges << badge if !resource.badges.include?(badge)
		end

		def self.remove( rid, badge_id, resource = false, badge = false )
			level = get_level( rid, badge_id )
			level.destroy
		end

	end

end