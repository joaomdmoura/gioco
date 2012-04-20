module Gioco

	class Resource

		def self.change_points( uid, points )
			p "=========================================="
			p "CHANGE POINTS"
			p "=========================================="
		end

	end

	class Badge

		def self.add( uid, badge_id )
			p "=========================================="
			p "ADD BADGE"
			p "=========================================="
		end

		def self.remove( uid, badge_id )
			p "=========================================="
			p "REMOVE BADGE"
			p "=========================================="
		end

	end

end