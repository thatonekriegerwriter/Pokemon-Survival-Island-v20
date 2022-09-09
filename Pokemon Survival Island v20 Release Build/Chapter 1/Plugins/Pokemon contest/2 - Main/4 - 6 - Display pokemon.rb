module ContestHall
	class Show

		# Old: pbPositionPokemonSprite_contest
		def position_pkmn_sprite(sprite,left,top)
			sprite.x = left - sprite.src_rect.width / 2
			sprite.y = top  - sprite.src_rect.height / 2
		end

		# Displays the sprite of the fastest pokemon, as per FindFastest
		# Old: pbDisplayFastest
		def display_fastest = display_pkmn_fast(0)

		# Old: pbDisplayPkmnFast
		def display_pkmn_fast(number)
			@sprites["pokemon#{number+1}"] = PokemonSprite.new(@vp2)
			@sprites["pokemon#{number+1}"].setPokemonBitmap(@pokeorder[number], true)
			@sprites["pokemon#{number+1}"].setOffset
			@sprites["pokemon#{number+1}"].mirror = true
			@sprites["pokemon#{number+1}"].z = 1
			position_pkmn_sprite(@sprites["pokemon#{number+1}"], 347, 256)
		end
		
		# Find pokemon's number (i.e. i - position for @pkmn1)
		# Old: pbCurrentPokeNum
		def pkmn_current(poke) = @pokeorder.index(poke)

		def pbDrawText
			create_sprite_2("overlay2", @viewport) if !@sprites["overlay2"]
			@sprites["overlay2"].z = 5
			clearTxt("overlay2")
			# Change graphic indicating what position the player's pokemon is at
			x = 347
			y = 96
			if !@sprites["playerspokebg"]
				create_sprite("playerspokebg", "playerspoke", @viewport)
				set_xy_sprite("playerspokebg", x, y)
			end
			4.times { |i| @sprites["playerspokebg"].y = y * i if @pokeorder[i] == @pkmn1 }
			text = []
			4.times { |i|
				string = "#{@pokeorder[i].name}"
				x = 353
				y = 5 + 95 * i
				text << [string, x, y, 0, Color.new(72,72,72), Color.new(160,160,160)]
			}
			drawTxt("overlay2", text)
		end
	end
end