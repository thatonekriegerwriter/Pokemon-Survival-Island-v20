module Pokeblock
	class Show

		def update_main
			update_arrow
			update_scene_pokeblock
			update_scene_pokemon
			update_features_pkmn
		end

		#---------------------#
		# Update page Pokemon #
		#---------------------#
		def update_scene_pokemon
			# Update ball (ball opaque)
			@pkmn[:size].times { |i|
				w = @sprites["ball #{i}"].src_rect.width
				set_src_xy_sprite("ball #{i}", w * (i == @pkmn[:index] && !@cancelButton? 1 : 0), 0)
			}
			# Update cancel
			set_visible_sprite("cancel", @cancelButton)
			# Pokemon
			pkmn = @pkmn[:name]
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, false, pkmn.egg?)
			@sprites["pkmn"].bitmap = Bitmap.new(file)
		end

		#-----------------------#
		# Update page Pokeblock #
		#-----------------------#
		def update_scene_pokeblock
			return if @style != 0
			set_visible_sprite("bg flavor", @processPkBlock == 0)
			5.times { |i| set_visible_sprite("flavor #{i}") }
			return if @processPkBlock != 0
			@flavor[@flavorPos][0].each_with_index { |fla, i| set_visible_sprite("flavor #{i}", fla > 0) }
		end

		#--------------#
		# Update arrow #
		#--------------#
		def update_arrow
			return if @style != 0
			set_visible_sprite("arrow", @processPkBlock == 0)
			@sprites["arrow"].y = 18
			return if @processPkBlock != 0
			@sprites["arrow"].y = 18 + 44 * pos_arrow
		end

		#-----------------------------------------------------------#
		# Update features (cool, beauty, cute, smart, tough, sheen) #
		#-----------------------------------------------------------#
		def update_features_pkmn
			pkmn = @pkmn[:name]
			arr = ["Cool", "Beauty", "Cute", "Smart", "Tough", "Sheen"]
			fea = [pkmn.cool, pkmn.beauty, pkmn.cute, pkmn.smart, pkmn.tough, pkmn.sheen]
			6.times { |i|
				x = 204 - 255 + fea[i]
				y = 142 + 42 * i
				set_xy_sprite("#{arr[i]} bar", x, y)
			}
		end

	end
end