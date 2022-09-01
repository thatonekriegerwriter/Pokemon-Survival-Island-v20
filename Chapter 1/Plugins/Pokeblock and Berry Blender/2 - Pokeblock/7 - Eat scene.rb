module Pokeblock
	class Show

		def eat_scene
			return if @style != 0
			return if @processPkBlock != 2
			# Scene
			create_sprite("eat scene", "Eat scene", @viewport) if !@sprites["eat scene"]
			set_visible_sprite("eat scene", true)
			# Pokemon
			pkmn = @pkmn[:name]
			oldf = [pkmn.cool, pkmn.beauty, pkmn.cute, pkmn.smart, pkmn.tough, pkmn.sheen]
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, false, pkmn.egg?)
			@sprites["pkmn 2"] = Sprite.new(@viewport) if !@sprites["pkmn 2"]
			@sprites["pkmn 2"].bitmap = Bitmap.new(file)
			h = @sprites["pkmn 2"].bitmap.height
			set_src_wh_sprite("pkmn 2", h, h)
			set_oxoy_sprite("pkmn 2", h / 2, h / 2)
			x = h / 2
			y = 120 + 142 / 2
			set_xy_sprite("pkmn 2", x, y)
			@sprites["pkmn 2"].mirror = true
			set_visible_sprite("pkmn 2", true)
			# Pokeblock
			create_sprite("pokeblock", "Pokeblock", @viewport) if !@sprites["pokeblock"]
			ox = @sprites["pokeblock"].bitmap.width / 2
			oy = @sprites["pokeblock"].bitmap.height / 2
			set_oxoy_sprite("pokeblock", ox, oy)
			x = Graphics.width - ox - 10
			y = 200
			set_xy_sprite("pokeblock", x, y)
			@sprites["pokeblock"].mirror = true
			set_visible_sprite("pokeblock", true)
			@sprites["pokeblock"].z = 1
			arr = [
				"Red",    "Blue",   "Pink",  "Green",     "Yellow",
				"Purple", "Indigo", "Brown", "Lite Blue", "Olive",
				"Gold", "Black", "White", "Gray"
			]
			create_sprite("flavor eat", @nameFla[@flavorPos], @viewport) if !@sprites["flavor eat"]
			set_sprite("flavor eat", @nameFla[@flavorPos])
			x = @sprites["pokeblock"].x - ox + @sprites["flavor eat"].bitmap.width
			y = @sprites["pokeblock"].y - oy + @sprites["flavor eat"].bitmap.height
			set_xy_sprite("flavor eat", x, y)
			set_visible_sprite("flavor eat", true)
			# Fade
			fade_out
			# Animation "Angle pokeblock"
			angle = 0
			14.times { |i|
				update_ingame
				i < 14 / 2 ? (angle += 2) : (angle -= 2)
				set_angle_sprite("pokeblock", angle)
			}
			# Animation "Jump falvor"
			t   = 0
			x0  = @sprites["flavor eat"].x
			y0  = @sprites["flavor eat"].y
			div = 90 / 20
			loop do
				Graphics.update
				update
				if @sprites["flavor eat"].x > 200
					r  = 35
					t += 0.1
					x  = -r*(t-Math.sin(t))
					y  = -r*(1-Math.cos(t))
					x += x0
					y += y0
					set_xy_sprite("flavor eat", x, y)
					if @sprites["flavor eat"].x.between?(200, 260)
						@sprites["pkmn 2"].x += div + 5
						@sprites["pkmn 2"].y -= div
					end
				else
					set_visible_sprite("flavor eat")
					break
				end
			end
			22.times {
				update_ingame
				@sprites["pkmn 2"].x += div / 2
				@sprites["pkmn 2"].y += div / 2
			}
			# Cry
			GameData::Species.play_cry(@pkmn[:name])
			pbMessage(_INTL("#{@pkmn[:name].name} ate #{@nameFla[@flavorPos]} Pokeblock"))
			# Fade
			fade_in
			# Set visible
			set_visible_sprite("eat scene")
			set_visible_sprite("pkmn 2")
			set_visible_sprite("pokeblock")
			set_visible_sprite("flavor eat")
			# Draw information
			draw_pokemon
			# Fade
			fade_out
			# Set animation "Up"
			6.times { |i|
				create_sprite("up animation #{i}", "Up", @viewport) if !@sprites["up animation #{i}"]
				x = 457 - @sprites["up animation #{i}"].bitmap.width
				y = 138 - @sprites["up animation #{i}"].bitmap.height + 42 * i
				set_xy_sprite("up animation #{i}", x, y)
				set_visible_sprite("up animation #{i}")
			}
			pbWait(10)
			# New (add feature, delete in global, delete @falvor, @nameFla)
			flavor = @flavor[@flavorPos]
			flavor[0] = BerryBlender.nature(pkmn.nature.id_number, flavor[0])
			pkmn.cool   += flavor[0][0]
			pkmn.beauty += flavor[0][1]
			pkmn.cute   += flavor[0][2]
			pkmn.smart  += flavor[0][3]
			pkmn.tough  += flavor[0][4]
			pkmn.sheen  += flavor[1]
			pkmn.cool    = 255 if pkmn.cool   > 255
			pkmn.beauty  = 255 if pkmn.beauty > 255
			pkmn.cute    = 255 if pkmn.cute   > 255
			pkmn.smart   = 255 if pkmn.smart  > 255
			pkmn.tough   = 255 if pkmn.tough  > 255
			pkmn.sheen   = 255 if pkmn.sheen  > 255
			newf = [pkmn.cool, pkmn.beauty, pkmn.cute, pkmn.smart, pkmn.tough, pkmn.sheen]
			# Update feature
			update_features_pkmn
			# Animation (Up)
			oldf.each_with_index { |f, i|
				next if f == newf[i]
				set_visible_sprite("up animation #{i}", true)
			}
			pbWait(30)
			6.times { |i| set_visible_sprite("up animation #{i}") }
			# Delete
			arr = [:flavor, :sheen, :level]
			# Define size to define position
			sizedefine = @flavorPos + 1
			# Define position to delete
			$PokemonGlobal.berry_blender.each { |k, v|
				next if v[:flavor].size == 0
				sizedefine - v[:flavor].size <= 0 ? break : (sizedefine -= v[:flavor].size)
			}
			3.times { |i| $PokemonGlobal.berry_blender[@nameFla[@flavorPos]][arr[i]].delete_at(sizedefine-1) }
			@nameFla.delete_at(@flavorPos)
			@flavor.delete_at(@flavorPos)
			# After pokemon eat flavor
			if @flavor.size == 0
				pbMessage(_INTL("You don't have any Pokeblocks, you can't continue to use!"))
				@exit = true
			else
				# Fade
				fade_in
				@processPkBlock = 0
				# Reset
				@flavorPos = 0
				$Trainer.party.each_with_index { |pkmn, i|
					next if pkmn.egg? || !pkmn.able?
					@pkmn[:name]  = pkmn
					@pkmn[:index] = i
					break
				}
			end
		end

	end
end