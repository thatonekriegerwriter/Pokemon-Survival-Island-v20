module Pokeathlon
	class FeedJuice

		#----------------------------#
		# Create decrease / increase #
		#----------------------------#
		def create_scene
			super
			5.times { |i|
				normal = @pkmn[:name].athlon_normal[i]
				x = 104 + (@sprites["star #{i} 0"].src_rect.width + 5) * (normal - 1)
				y = 49 + 64 * i - 2
				# Increase
				create_sprite("incr #{i}", "Increase", @viewport)
				set_xy_sprite("incr #{i}", x, y)
				set_visible_sprite("incr #{i}")
				# Decrease
				create_sprite("decr #{i}", "Decrease", @viewport)
				set_xy_sprite("decr #{i}", x, y)
				set_visible_sprite("decr #{i}")
			}
			@frames_incr_decr = [0, 0, false] # Frames, Times, Trigger
		end

		#-------------------------------------------#
		# Show stats if this increases or decreases #
		#-------------------------------------------#
		def update_star(speed=nil)
			5.times { |i|
				normal = @pkmn[:name].athlon_normal[i]
				change = @pkmn[:name].athlon_normal_changed[i]
				5.times { |j|
					set_visible_sprite("star #{i} #{j}", @pkmn[:name].athlon_max[i] > j)
					w = @sprites["star #{i} #{j}"].src_rect.width
					if change == 0
						x = 0
					else
						x = j > change - 1 ? 0 : change < normal ? 2 : change == normal ? 1 : 3
					end
					set_src_xy_sprite("star #{i} #{j}", x * w, 0)
				}
				# Increase / Decrease
				next unless @sprites["incr #{i}"]
				x = 104 + (@sprites["star #{i} 0"].src_rect.width + 5) * (normal - 1)
				y = 49 + 64 * i - 2
				y += @frames_incr_decr[1]
				set_xy_sprite("incr #{i}", x, y)
				set_xy_sprite("decr #{i}", x, y)
				move = speed.nil? ? 8 : speed
				if @frames_incr_decr[0] % move == 0
					if @frames_incr_decr[2]
						@frames_incr_decr[1] -= 1
						@frames_incr_decr[2]  = false if @frames_incr_decr[1] < 0
					else
						@frames_incr_decr[1] += 1
						@frames_incr_decr[2]  = true if @frames_incr_decr[1] > 3
					end
				end
				set_visible_sprite("incr #{i}", change > normal)
				set_visible_sprite("decr #{i}", change < normal)
			}
			return unless @sprites["incr 0"]
			@frames_incr_decr[0] += 1
		end

	end
end