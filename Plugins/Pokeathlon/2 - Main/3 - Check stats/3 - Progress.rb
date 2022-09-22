module Pokeathlon
	class CheckStats

		def show
			# Create scene
			create_scene
			# Play cry
			cry_pkmn
			loop do
				update_ingame
				break if @exit
				# Update
				update_main
				# Set input
				set_input_check
				# Draw
				draw_text
			end
		end

		#--------------#
		# Create scene #
		#--------------#
		def create_scene
			# Background
			create_sprite("bg", "Scene", @viewport)
			set_xy_sprite("bg", 0, 0)
			# Pokemon
			pkmn = @pkmn[:name]
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, false, pkmn.egg?)
			set_bitmap("pkmn", file, @viewport)
			h = @sprites["pkmn"].bitmap.height
			set_src_wh_sprite("pkmn", h, h)
			set_oxoy_sprite("pkmn", h / 2, h / 2)
			x = 308 + 182 / 2
			y = 128 + 182 / 2
			set_xy_sprite("pkmn", x, y)
			# Draw star
			# Stats
			5.times { |i|
				# Star
				5.times { |j|
					create_sprite("star #{i} #{j}", "Star", @viewport)
					w = @sprites["star #{i} #{j}"].bitmap.width / 4
					h = @sprites["star #{i} #{j}"].bitmap.height
					set_src_wh_sprite("star #{i} #{j}", w, h)
					x = 104 + (w + 5) * j
					y = 81 + 64 * i - 2
					set_xy_sprite("star #{i} #{j}", x, y)
				}
			}
			# Update
			update_star
			# Markings
			6.times { |i|
				set_bitmap("mark #{i}", "Graphics/Pictures/Summary/markings", @viewport)
				w = @sprites["mark #{i}"].bitmap.width / 6
				h = @sprites["mark #{i}"].bitmap.height / 2
				set_src_wh_sprite("mark #{i}", w, h)
				set_src_xy_sprite("mark #{i}", w * i, 0)
				x = 490 - 5 - @sprites["mark #{i}"].bitmap.width + w * i
				y = 310 - 5 - h
				set_xy_sprite("mark #{i}", x, y)
			}
			# Text
			create_sprite_2("pkmn text", @viewport)
		end

		def cry_pkmn = (GameData::Species.play_cry(@pkmn[:name]))

	end
end