module Pokeathlon
	class Minigame_Main

		# pkmn: Array
		# bitmap + oxoy
		def icon_pkmn_shadow_bitmap(pkmn)
			sha = -1
			pkmn.size.times { |i|
				# Shadow
				create_sprite("shadow icon pkmn #{i}", "shadow", @viewport, "00 - Main")
				w = @sprites["shadow icon pkmn #{i}"].bitmap.width / 4
				h = @sprites["shadow icon pkmn #{i}"].bitmap.height
				set_src_wh_sprite("shadow icon pkmn #{i}", w, h)
				sha += 1 if i % 3 == 0
				set_src_xy_sprite("shadow icon pkmn #{i}", sha * w, 0)
				set_oxoy_sprite("shadow icon pkmn #{i}", w / 2, h / 2)
				# Pokemon
				file = GameData::Species.icon_filename_from_pokemon(pkmn[i])
				set_bitmap("icon pkmn #{i}", file, @viewport)
				w = @sprites["icon pkmn #{i}"].bitmap.width / 2
				h = @sprites["icon pkmn #{i}"].bitmap.height
				set_src_wh_sprite("icon pkmn #{i}", w, h)
				set_oxoy_sprite("icon pkmn #{i}", w / 2, h / 2)
			}
		end

		# x, y: coordinate (start to calculate)
		def icon_pkmn_shadow_xy(pkmn, x, y, disx=0, disy=0)
			pkmn.size.times { |i|
				xx = x + i * disx
				yy = y + i * disy
				set_xy_sprite("icon pkmn #{i}", xx, yy)
				yy += @sprites["icon pkmn #{i}"].src_rect.height / 2
				set_xy_sprite("shadow icon pkmn #{i}", xx, yy)
			}
		end

	end
end