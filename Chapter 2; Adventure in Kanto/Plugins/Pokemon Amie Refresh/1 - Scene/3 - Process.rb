module PkmnAR
	class Show

		def show
			create_scene
			loop do
				update_ingame
				if checkInput(Input::BACK)
					# Fade
					fade_in if @bg != 0
					# Set @bg
					@bg == 0 ? (@exit = true) : (@bg = 0)
					# Background
					update_bg
					# Update icon (aff, full, enjoy)
					update_icon_aff_full_enjoy
				end
				break if @exit
				# Update
				update_main
				# Text
				draw_text
				# Count frames
				@frames += 1
				# Fade
				fade_out
			end
		end

		#--------------#
		# Create scene #
		#--------------#
		def create_scene
			# Background
			create_sprite("bg", set_file_bg, @viewport)
			# Mouse
			create_mouse_bitmap
			# Pokemon
			create_pokemon
			# Switch
			create_sprite("switch", "switch", @viewport)
			ox = @sprites["switch"].bitmap.width
			oy = @sprites["switch"].bitmap.height
			set_oxoy_sprite("switch", ox, oy)
			x = Graphics.width
			y = Graphics.height
			set_xy_sprite("switch", x, y)
			# Back
			create_sprite("back", "back", @viewport)
			oy = @sprites["back"].bitmap.height
			set_oxoy_sprite("back", 0, oy)
			y = Graphics.height
			set_xy_sprite("back", 0, y)
			# Feed
			create_sprite("feed", "feed", @viewport)
			ox = @sprites["feed"].bitmap.width / 2
			oy = @sprites["feed"].bitmap.height / 2
			set_oxoy_sprite("feed", ox, oy)
			set_xy_sprite("feed", ox, oy)
			@sprites["feed"].z = 2
			# Icon pokemon
			create_icon_pokemon
			# Create icon features
			create_aff_full_enjoy_icon
			# Text
			create_sprite_2("pkmn text", @viewport)
			create_sprite_2("quantity text", @viewport)
			@sprites["quantity text"].z = 1
		end

		# Sprite: mouse
		def create_mouse_bitmap
			create_sprite("mouse", "hand2", @viewport)
			ox = @sprites["mouse"].bitmap.width  / 2
			oy = @sprites["mouse"].bitmap.height / 2
			@sprites["mouse"].z = 5
			# Update
			update_sprites_mouse
		end

		# Sprite: pokemon
		def create_pokemon
			@sprites["pkmn"] = Sprite.new(@viewport)
			update_bitmap_pokemon(@pkmn[:index])
			h = @sprites["pkmn"].bitmap.height
			set_src_wh_sprite("pkmn", h, h)
			set_oxoy_sprite("pkmn", h / 2, h / 2)
			x = Graphics.width / 2
			y = Graphics.height / 2
			set_xy_sprite("pkmn", x, y)
			store_size_pkmn
		end

		def create_icon_pokemon
			$Trainer.party.each_with_index { |pkmn, i|
				@sprites["icon #{i}"] = Sprite.new(@viewport)
				species = pkmn.species
				species = GameData::Species.get(species).species
				file = GameData::Species.icon_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?, pkmn.egg?)
				@sprites["icon #{i}"].bitmap = Bitmap.new(file)
				h = @sprites["icon #{i}"].bitmap.height
				set_src_wh_sprite("icon #{i}", h, h)
				ox = @sprites["icon #{i}"].src_rect.width / 2
				oy = @sprites["icon #{i}"].src_rect.height / 2
				set_oxoy_sprite("icon #{i}", ox, oy)
				x = 42 + i * 76 + 28
				y = 201 + 23
				set_xy_sprite("icon #{i}", x, y)
				set_visible_sprite("icon #{i}")
			}
		end

		#------------------------#
		# Set name of background #
		#------------------------#
		def set_bg_0
			if $PokemonGlobal.surfing
				backdrop = "water"   # This applies wherever you are, including in caves
			elsif GameData::MapMetadata.exists?($game_map.map_id)
				back = GameData::MapMetadata.get($game_map.map_id).battle_background
				backdrop = back if back && back != ""
			end
			backdrop = "indoor1" if !backdrop
			return backdrop.capitalize
		end

		def set_file_bg
			dir  = "Graphics/Pictures/Pokemon Amie/"
			file = "#{set_bg_0}"
			file = "Field" if !pbResolveBitmap("#{dir}#{file}")
			return file
		end

		#-----------------#
		# Move 'feed' bar #
		#-----------------#
		def move_feed_bar
			if !@sprites["feedshow"]
				create_sprite("feedshow", "feedshow", @viewport)
				@sprites["feedshow"].oy = @sprites["feedshow"].bitmap.height / 2
				x = @sprites["feed"].x
				y = @sprites["feed"].y
				set_xy_sprite("feedshow", x, y)
				set_zoom_sprite("feedshow", 0.2, 0.2)
				# Create item
				create_show_item
			end
			set_visible_sprite("mouse")
			loop do
				update_ingame
				if @feedshow
					# Reset icon
					update_reset_bitmap
					set_visible_sprite("feedshow", true)
					8.times {
						@sprites["feedshow"].zoom_x += 0.1
						pbWait(1)
					}
					4.times {
						@sprites["feedshow"].zoom_y += 0.2
						# Update icon
						update_zoom_icon_item(true)
						pbWait(1)
					}
				else
					4.times {
						@sprites["feedshow"].zoom_y -= 0.2
						# Update icon
						update_zoom_icon_item
						# Clear text
						clearTxt("quantity text")
						pbWait(1)
					}
					8.times {
						@sprites["feedshow"].zoom_x -= 0.1
						pbWait(1)
					}
					set_visible_sprite("feedshow")
					# Reset icon
					update_reset_bitmap
				end
				# Update mouse
				update_sprites_mouse
				break
			end
		end

		#---------------#
		# Item (bitmap) #
		#---------------#
		def max_item_show = 7

		def create_show_item
			return if @item.size <= 0
			max  = max_item_show
			size = @item.size > max ? max : @item.size
			size.times { |i|
				next if @sprites["item #{i}"]
				@sprites["item #{i}"] = Sprite.new(@viewport)
				file = GameData::Item.icon_filename(@item[i])
				@sprites["item #{i}"].bitmap = Bitmap.new(file)
				ox = @sprites["item #{i}"].bitmap.width / 2
				oy = @sprites["item #{i}"].bitmap.height / 2
				set_oxoy_sprite("item #{i}", ox, oy)
				x = 80 + ox + (ox * 2 + 15) * i
				y = @sprites["feed"].y
				set_xy_sprite("item #{i}", x, y)
				set_zoom_sprite("item #{i}", 0, 0)
			}
		end

		#--------------------------------#
		# Affection, Fullness, Enjoyment #
		#--------------------------------#
		def create_aff_full_enjoy_icon
			namesprite = ["aff", "full", "enjoy"]
			namefile   = ["affect", "full", "enjoy"]
			3.times { |i|
				5.times { |j|
					create_sprite("#{namesprite[i]} #{j}", "#{namefile[i]}", @viewport)
					w = @sprites["#{namesprite[i]} #{j}"].bitmap.width / 2
					h = @sprites["#{namesprite[i]} #{j}"].bitmap.height
					set_src_wh_sprite("#{namesprite[i]} #{j}", w, h)
					x = 212 + (w + 8) * j
					y = 70 + (32 - h) / 2 + 32 * i
					set_xy_sprite("#{namesprite[i]} #{j}", x, y)
					set_visible_sprite("#{namesprite[i]} #{j}")
				}
			}
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