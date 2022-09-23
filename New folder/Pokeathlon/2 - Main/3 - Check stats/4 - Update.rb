module Pokeathlon
	class CheckStats

		def update_main
			update_pkmn
			update_star
			update_marking
		end

		#-------------------------#
		# Update stats of pokemon #
		#-------------------------#
		def update_star
			5.times { |i|
				5.times { |j|
					set_visible_sprite("star #{i} #{j}", @pkmn[:name].athlon_max[i] > j)
					w = @sprites["star #{i} #{j}"].src_rect.width
					if @pkmn[:name].athlon_normal[i] == 0
						x = 0
					else
						x = @pkmn[:name].athlon_normal[i] - 1 < j ? 0 : w
					end
					set_src_xy_sprite("star #{i} #{j}", x, 0)
				}
			}
		end
		
		#-------------------------#
		# Update pokemon (bitmap) #
		#-------------------------#
		def update_pkmn
			pkmn = @pkmn[:name]
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, false, pkmn.egg?)
			@sprites["pkmn"].bitmap = Bitmap.new(file)
		end

		#---------------------------#
		# Update marking of pokemon #
		#---------------------------#
		def update_marking
			pkmn = @pkmn[:name]
			markings = pkmn.markings
			6.times { |i|
				h = @sprites["mark #{i}"].src_rect.height
				y = markings&(1<<i) != 0 ? h : 0
				@sprites["mark #{i}"].src_rect.y = y
			}
		end
	end
end