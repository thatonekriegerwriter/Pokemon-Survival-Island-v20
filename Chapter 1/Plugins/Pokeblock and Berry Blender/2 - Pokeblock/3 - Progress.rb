module Pokeblock
	class Show

		def show
			if @style == 0
				if @flavor.size == 0
					pbMessage(_INTL("You don't have any PokeBlocks!"))
					@exit = true
				end
				return if @exit
			end
			# Create scene
			create_scene_pokemon
			create_scene_flavor
			# Create bitmap to draw
			create_bitmap_text_to_draw
			loop do
				update_ingame
				break if @exit
				# Fade
				if @processPkBlock != 2 && @countFade >= 2
					fade_out
					@countFade = 0
					# Cry
					GameData::Species.play_cry(@pkmn[:name]) if @processPkBlock == 1
				end
				@countFade += 1 if @fade
				# Update
				update_main
				# Input
				set_input
				# Draw
				draw_text
				# Scene
				eat_scene
			end
		end

		#-------#
		# Scene #
		#-------#
		# Pokemon
		def create_scene_pokemon
			# Flavor bar
			pkmn = @pkmn[:name]
			arr = ["Cool", "Beauty", "Cute", "Smart", "Tough", "Sheen"]
			fea = [pkmn.cool, pkmn.beauty, pkmn.cute, pkmn.smart, pkmn.tough, pkmn.sheen]
			6.times { |i|
				create_sprite("#{arr[i]} bar", "Bar_#{arr[i]}", @viewport)
				x = 204 - 255 + fea[i]
				y = 142 + 42 * i
				set_xy_sprite("#{arr[i]} bar", x, y)
			}
			# Scene pokemon
			create_sprite("bg pkmn", "Scene_pokemon", @viewport)
			# Cancel
			create_sprite("cancel", "Cancel", @viewport)
			x = 470
			y = 290
			set_xy_sprite("cancel", x, y)
			set_visible_sprite("cancel")
			# Pokemon
			@pkmn[:size].times { |i|
				create_sprite("ball #{i}", "ball", @viewport)
				w = @sprites["ball #{i}"].bitmap.width / 2
				h = @sprites["ball #{i}"].bitmap.height
				set_src_wh_sprite("ball #{i}", w, h)
				set_src_xy_sprite("ball #{i}", w * (i == @pkmn[:index] ? 1 : 0), 0)
				set_oxoy_sprite("ball #{i}", w / 2, h / 2)
				x = 470 + 42 / 2
				y = 290 - (w + 15) * (@pkmn[:size] - i)
				set_xy_sprite("ball #{i}", x, y)
			}
			# Pokemon
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, false, pkmn.egg?)
			@sprites["pkmn"] = Sprite.new(@viewport)
			@sprites["pkmn"].bitmap = Bitmap.new(file)
			h = @sprites["pkmn"].bitmap.height
			set_src_wh_sprite("pkmn", h, h)
			set_oxoy_sprite("pkmn", h / 2, h / 2)
			x = 164 / 2
			y = 120 + 142 / 2
			set_xy_sprite("pkmn", x, y)
			# Cry
			GameData::Species.play_cry(@pkmn[:name]) if @style != 0
		end

		# Flavor
		def create_scene_flavor
			return if @style == 1
			# Background
			create_sprite("bg flavor", "Scene_block", @viewport)
			# Flavor
			arr = ["Red", "Blue", "Pink", "Green", "Yellow"]
			5.times { |i|
				create_sprite("flavor #{i}", arr[i], @viewport)
				x = i < 3 ? 14 : 110
				y = 282 + (i % 3) * 32
				set_xy_sprite("flavor #{i}", x, y)
				set_visible_sprite("flavor #{i}")
			}
			# Arrow
			create_sprite("arrow", "Arrow", @viewport)
			x = 255
			y = 18
			set_xy_sprite("arrow", x, y)
		end

		# Text
		def create_bitmap_text_to_draw
			create_sprite_2("list text", @viewport) if @style == 0
			create_sprite_2("pkmn text", @viewport)
		end

		#------------------#
		# Max list to show #
		#------------------#
		def max_list_flavor = 8

		def pos_arrow
			return if @style != 0
			return if @processPkBlock != 0
			max = @flavor.size
			maxshow  = max_list_flavor
			position = @flavorPos
			return position if max > 0 && max < maxshow
			return position if position < maxshow / 2
			return maxshow / 2 - 1 if position < max - maxshow / 2
			return (maxshow - 1) - ((max - 1) - position)
		end

		#------#
		# Fade #
		#------#
		def fade_in
			return if @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				@viewport.color = Color.new(0, 0, 0, i * alphaDiff)
				pbWait(1)
			}
			@fade = true
		end

		def fade_out
			return unless @fade
			numFrames = (Graphics.frame_rate*0.4).floor
  		alphaDiff = (255.0/numFrames).ceil
			(0..numFrames).each { |i|
				@viewport.color = Color.new(0, 0, 0, (numFrames - i) * alphaDiff)
				pbWait(1)
			}
			@fade = false
		end

	end
end