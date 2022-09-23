module Pokeathlon
	class JuiceBlender

		def update_main
			update_scene
		end

		def update_scene
			@sprites["stripes"].ox += 0.2
			@sprites["stripes"].oy += 0.2
		end

		def update_bottle
		y2 = Graphics.height / 2 - @sprites["bottle"].src_rect.height / 2
		if @changeBottle
				x2 = Graphics.width * 3 / 4 - @sprites["bottle"].src_rect.width / 2
					loop do
					update_ingame
					break if @sprites["bottle"].x >= x2
					x1 = @sprites["bottle"].x
					divx = x2 / 10.0
					x1 += divx
					x1  = x2 if x1 > x2
					set_xy_sprite("bottle", x1, y2)
					x = @sprites["bottle"].x + 6
					y = @sprites["bottle"].y + 16 - @sprites["lid"].src_rect.height
					set_xy_sprite("lid", x, y)
				end
			else
				x2 = Graphics.width  / 2 - @sprites["bottle"].src_rect.width / 2
				loop do
					update_ingame
					break if @sprites["bottle"].x <= x2
					x1 = @sprites["bottle"].x
					divx = x2 / 10.0
					x1 -= divx
					x1  = x2 if x1 < x2
					set_xy_sprite("bottle", x1, y2)
					x = @sprites["bottle"].x + 6
					y = @sprites["bottle"].y + 16 - @sprites["lid"].src_rect.height
					set_xy_sprite("lid", x, y)
				end
			end
		end

		def update_message(mess="")
			pbMessage(_INTL("#{mess}")) {
				update
				update_scene
			}
		end

		def update_graphics_bottle
			return if $PokemonGlobal.apricorn_juice_step < STEP_APRIJUICE
			w = @sprites["bottle"].src_rect.width
			x = $PokemonGlobal.apricorn_juice_strongest_first.nil? ? $PokemonGlobal.apricorn_juice_strongest_second : $PokemonGlobal.apricorn_juice_strongest_first
			set_src_xy_sprite("bottle", (x + 1) * w, 0)
		end

	end
end