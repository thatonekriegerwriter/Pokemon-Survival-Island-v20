module ContestHall
	class NewMethod

		def set_switch(map, event, switch='A', set=true)
			$game_self_switches[[map, event, switch]] = set
			return unless set
			$game_map.need_refresh = set
			loop do
				break if !$game_self_switches[[map, event, switch]]
				pbWait(1)
			end
		end

		def transfer(id, x, y, face=false)
			vp = Viewport.new(0,0,Graphics.width,Graphics.height)
			vp.color = Color.new(0,0,0,0)
			16.times do
				next if vp.nil?
				vp.color.alpha += 16
				pbWait(1)
			end
			$MapFactory = PokemonMapFactory.new(id)
			$game_player.moveto(x, y)
			$game_player.refresh
			!face ? $game_player.turn_right : $game_player.turn_down
			$game_map.autoplay
			$game_map.update
			8.times { Graphics.update }
			16.times {
				next if vp.nil?
				vp.color.alpha -= 16
				pbWait(1)
			}
		end

	end
end