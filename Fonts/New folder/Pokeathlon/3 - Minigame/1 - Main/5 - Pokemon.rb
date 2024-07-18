module Pokeathlon
	class Minigame_Main

		def find_file_pokemon_play(species, form = 0, gender = 0, shiny = false, shadow = false, subfolder = "")
			path = "Graphics/Characters/Followers"
      try_subfolder = sprintf("%s/", subfolder)
			try_species = species
      try_form    = (form > 0) ? sprintf("_%d", form) : ""
      try_gender  = (gender == 1) ? "_female" : ""
      try_shadow  = (shadow) ? "_shadow" : ""
      factors = []
			factors.push([4, sprintf("%s shiny/", subfolder), try_subfolder]) if shiny
      factors.push([3, try_shadow, ""]) if shadow
      factors.push([2, try_gender, ""]) if gender == 1
      factors.push([1, try_form, ""]) if form > 0
      factors.push([0, try_species, "000"])
      # Go through each combination of parameters in turn to find an existing sprite
      for i in 0...2 ** factors.length
        # Set try_ parameters for this combination
        factors.each_with_index do |factor, index|
          value = ((i / (2 ** index)) % 2 == 0) ? factor[1] : factor[2]
          case factor[0]
          when 0 then try_species   = value
          when 1 then try_form      = value
          when 2 then try_gender    = value
          when 3 then try_shadow    = value
          when 4 then try_subfolder = value   # Shininess
          end
        end
        # Look for a graphic matching this combination's parameters
        try_species_text = try_species
        ret = pbResolveBitmap(sprintf("%s%s%s%s%s%s", path, try_subfolder,
					try_species_text, try_form, try_gender, try_shadow))
			 return ret if ret
      end
      return nil
		end

		def file_pokemon_play(pkmn) = find_file_pokemon_play(pkmn.species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)
		def front_file_pokemon_play(pkmn) = GameData::Species.front_sprite_filename(pkmn.species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)

		# pkmn: Array
		# bitmap + oxoy
		def pkmn_shadow_bitmap(pkmn, orifile=false)
			sha = -1
			pkmn.size.times { |i|
				# Shadow
				create_sprite("shadow pkmn #{i}", "shadow", @viewport, "00 - Main")
				w = @sprites["shadow pkmn #{i}"].bitmap.width / 4
				h = @sprites["shadow pkmn #{i}"].bitmap.height
				set_src_wh_sprite("shadow pkmn #{i}", w, h)
				sha += 1 if i % 3 == 0
				set_src_xy_sprite("shadow pkmn #{i}", sha * w, 0)
				set_oxoy_sprite("shadow pkmn #{i}", w / 2, h / 2)
				# Pokemon
				file = orifile ? front_file_pokemon_play(pkmn[i]) : file_pokemon_play(pkmn[i])
				set_bitmap("pkmn #{i}", file, @viewport)
				if orifile
					set_zoom_sprite("shadow pkmn #{i}", 2, 2)

					w = @sprites["pkmn #{i}"].bitmap.height
					h = @sprites["pkmn #{i}"].bitmap.height
				else
					w = @sprites["pkmn #{i}"].bitmap.width / 4
					h = @sprites["pkmn #{i}"].bitmap.height / 4
				end
				set_src_wh_sprite("pkmn #{i}", w, h)
				set_oxoy_sprite("pkmn #{i}", w / 2, h / 2)
			}
		end

		# x, y: coordinate (start to calculate)
		def pkmn_shadow_xy(pkmn, x, y, disx=0, disy=0)
			pkmn.size.times { |i|
				xx = x + i * disx
				yy = y + i * disy
				set_xy_sprite("pkmn #{i}", xx, yy)

				# Store coordinate (pokemon)
				@store["pkmn #{i}"] = [xx, yy]

				yy += @sprites["pkmn #{i}"].src_rect.height / 2
				set_xy_sprite("shadow pkmn #{i}", xx, yy)
			}
		end

		# This def like `def pkmn_shadow_xy` but it changes when condition is true
		# Use to show pokemon (course begins)
		def pkmn_shadow_xy_condition(pkmn, x, y, condition=1, disx=0, disy=0)
			change = -1
			pkmn.size.times { |i|
				change += 1 if i % condition == 0
				xx = x + change * disx
				yy = y + (i % condition) * disy
				set_xy_sprite("pkmn #{i}", xx, yy)

				# Store coordinate (pokemon)
				@store["pkmn #{i}"] = [xx, yy]

				yy += @sprites["pkmn #{i}"].src_rect.height / 2
				set_xy_sprite("shadow pkmn #{i}", xx, yy)
			}
		end

		# Use when pokemon change coordinate
		# str: number of this pokemon
		def pkmn_shadow_change_xy(str, disx=0, disy=0)
			@sprites["pkmn #{str}"].x += disx
			@sprites["pkmn #{str}"].y += disy
			x = @sprites["pkmn #{str}"].x
			y = @sprites["pkmn #{str}"].y + @sprites["pkmn #{str}"].src_rect.height / 2
			set_xy_sprite("shadow pkmn #{str}", x, y)
		end

		# Reset x, y
		def pkmn_shadow_reset_xy(str)
			@sprites["pkmn #{str}"].x = @store["pkmn #{str}"][0]
			@sprites["pkmn #{str}"].y = @store["pkmn #{str}"][1]
			x = @sprites["pkmn #{str}"].x
			y = @sprites["pkmn #{str}"].y + @sprites["pkmn #{str}"].src_rect.height / 2
			set_xy_sprite("shadow pkmn #{str}", x, y)
		end

		# pkmn: range [min, max] -> same src_rect.x, src_rect.y
		def pkmn_shadow_src_xy(pkmn, srcx=nil, srcy=nil)
			(pkmn.min..pkmn.max).each { |i|
				w = @sprites["pkmn #{i}"].src_rect.width
				h = @sprites["pkmn #{i}"].src_rect.height
				@sprites["pkmn #{i}"].src_rect.x = srcx * w if !srcx.nil?
				@sprites["pkmn #{i}"].src_rect.y = srcy * h if !srcy.nil?
			}
		end

		#----------------------#
		# Check pokemon bitmap #
		#----------------------#
		#--------#
		# Height #
		#--------#
		def height_top_bot(bitmap, bottom=false)
			return 0 if !bitmap
			if bottom
				(1..bitmap.height).each { |i|
					(0..bitmap.width-1).each { |j|
						return bitmap.height - i + 1 if bitmap.get_pixel(j, bitmap.height - i).alpha > 0
					} 
				}
			else
				h = []
				(1..bitmap.height).each { |i| 
					(0..bitmap.width-1).each { |j|
						h << bitmap.height - i if bitmap.get_pixel(j, bitmap.height - i).alpha > 0
					} 
				}
				return h.min
			end
			return 0
		end

		def height_bitmap(bitmap) = self.height_top_bot(bitmap,true) - self.height_top_bot(bitmap)

		#-------#
		# Width #
		#-------#
		def width_left_right(bitmap, right=false)
			return 0 if !bitmap
			if right
				(1..bitmap.width).each { |i|
					(0..bitmap.height-1).each { |j|
						return bitmap.width - i + 1 if bitmap.get_pixel(bitmap.width - i, j).alpha > 0
					} 
				}
			else
				w = []
				(1..bitmap.width).each { |i| 
					(0..bitmap.height-1).each { |j|
						w << bitmap.width - i if bitmap.get_pixel(bitmap.width - i, j).alpha > 0
					} 
				}
				return w.min
			end
			return 0
		end

		def width_bitmap(bitmap) = self.width_left_right(bitmap,true) - self.width_left_right(bitmap)

	end
end