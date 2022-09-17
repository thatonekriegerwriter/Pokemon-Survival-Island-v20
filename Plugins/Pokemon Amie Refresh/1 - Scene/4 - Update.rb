module PkmnAR
	class Show
		
		#--------#
		# Update #
		#--------#
		def update_main
			# Click mouse
			delayMouse(DELAY_MOUSE)
			update_mouse
			# Sprite mouse
			update_sprites_mouse
			# Icon pokemon
			update_icon_pkmn
			# Pokemon
			update_visible_pkmn
			# Feature
			update_sprite_feature
		end

		#------------#
		# Background #
		#------------#
		def update_bg
			case @bg
			when 0 then set_sprite("bg", set_file_bg)
			when 1 then set_sprite("bg", "bgswitch#{@bgSwitch+1}")
			end
		end

		#---------#
		# Feature #
		#---------#
		def update_sprite_feature
			set_visible_sprite("switch", @bg==0)
			set_visible_sprite("feed", @bg==0)
		end

		#-------#
		# Mouse #
		#-------#
		def update_sprites_mouse
			set_xy_sprite("mouse", @oldm[0], @oldm[1])
			set_visible_sprite("mouse", System.mouse_in_window)
		end

		def update_mouse
			update_mouse_feed
			return if @feed
			# Update feed show
			if @feedshow && @item.size > 0 && (@storeNItCPL != 0 || @storeNItCPR != 0)
				@storeNItCPL = 0
				@storeNItCPR = 0
			end
			# Start mouse
			return if @delay <= DELAY_MOUSE
			content = check_mouse
			case content
			when :back # Back
				return unless clickedMouse?
				click_sprite_zoom("back")
				# Fade
				if @bg != 0
					fade_in
					# Store pixel again
					store_size_pkmn
				end
				# Set @bg
				@bg == 0 ? (@exit = true) : (@bg = 0)
				# Background
				update_bg
				# Update icon (aff, full, enjoy)
				update_icon_aff_full_enjoy
			when :switch # Switch new page
				return unless clickedMouse?
				click_sprite_zoom("switch")
				if @feedshow
					# Hide feed bar
					@feedshow = false
					# Move bar
					move_feed_bar
				end
				# Fade
				fade_in
				# Change into background switch
				@bg = 1
				# Background
				update_bg
				# Update icon (aff, full, enjoy)
				update_icon_aff_full_enjoy
			when :feed # Feed bar (open - close)
				return unless clickedMouse?
				click_sprite_zoom("feed")
				@feedshow = !@feedshow
				# Move bar
				move_feed_bar

			when :mouse_on_bar # Position of mouse is on feed bar

				if @time[:feedshow] == 0
					@time[:feedshow] = Input.time?(Input::MOUSELEFT)
					if @time[:feedshow] == 0
						@movem[:feedshow] = @oldm.clone
						set_sprite("mouse", "hand2")
						return
					end
				end
				time = Input.time?(Input::MOUSELEFT)
				if time - @time[:feedshow] < 1 # 0.000 001 second
					set_sprite("mouse", "hand2")
					@movem[:feedshow] = @oldm.clone
					@time[:feedshow]  = 0
					return
				end
				set_sprite("mouse", "hand1")
				# Maximum items
				max  = max_item_show
				# Slide
				if @movem[:feedshow] != @oldm
					
					@time[:feedshow] = time
					# 48: length of bitmap 'item', 15 is distance between two bitmaps -> 48 + 15 = 63
					betw = 48 + 15
					# Check change to set again bitmap
					change = false
					# Distance to move
					move = @movem[:feedshow][0] - @oldm[0]
					# Move right
					if move > 0
						# Return
						if @posItem + max > @item.size
							@movem[:feedshow] = @oldm.clone
							return
						end
						# Move
						@storeNItCPL -= @storeNItCPR if @storeNItCPR != 0 && @posItem + max == @item.size
						@storeNItCPL -= move
						@storeNItCPR = 0
					# Move left
					else
						# Return
						if @posItem == 0 && move < 0 && @storeNItCPL == 0 && @storeNItCPR == 0
							@movem[:feedshow] = @oldm.clone
							return
						end
						# Move
						@storeNItCPR += @storeNItCPL if @storeNItCPL != 0
						@storeNItCPR -= move
						@storeNItCPL  = 0
					end
					# Reset
					if @storeNItCPL <= -betw
						div = @storeNItCPL / -betw
						@posItem += div
						@posItem  = @item.size - max if @posItem + max > @item.size
						# Reset values
						change = true
						@storeNItCPL = 0
					elsif @storeNItCPR >= betw
						div = @storeNItCPR / betw
						@posItem -= div
						@posItem  = 0 if @posItem < 0
						# Reset values
						change = true
						@storeNItCPR = 0
					end
					# Update bitmap
					if change
						update_position_icon_item
						change = false
					end
					# Set again
					@movem[:feedshow] = @oldm.clone

				# Feed if it can be do it
				else

					time = Input.time?(Input::MOUSELEFT)
					return if time - @time[:feedshow] < 10 ** 6 * 2 # 2 seconds
					@time[:feedshow] = time
					@storeItem.each_with_index { |di, i|
						next unless areaMouse?(di)
						@itemName = @itemF[i]
						@feed = true
						return
					}
					
				end
			when 0, 1, 2, 3, 4, 5 # Switch pokemon
				return unless clickedMouse?
				return if content + 1 > @pkmn[:party].size
				return unless @pkmn[:party][content]
				@bgSwitch = content
				# Background
				update_bg
				# Pokemon
				update_bitmap_pokemon(content)
				# Update icon (aff, full, enjoy)
				update_icon_aff_full_enjoy
			else
				# Touch pokemon
				return if @bg == 1
				if @movem[:pkmn] == @oldm || !areaMouse?(@sizePkmn)
					set_sprite("mouse", "hand2")
					@around -= 1
					@around  = 0 if @around < 0
					@movem[:pkmn] = @oldm.clone
					@time[:pkmn]  = 0
					return
				end
				if @time[:pkmn] == 0
					@time[:pkmn] = Input.time?(Input::MOUSELEFT)
					return if @time[:pkmn] == 0
				end
				time = Input.time?(Input::MOUSELEFT)
				if time - @time[:pkmn] < 1 # 0.000 001 second
					set_sprite("mouse", "hand2")
					@movem[:pkmn] = @oldm.clone
					return
				end
				set_sprite("mouse", "hand1")
				@around += 1
				if @around >= MAX_AROUND
					PkmnAR.change_amie_stats(@pkmn[:name], :pet)
					pbSEPlay("pet.ogg", 90, 100)
					update_show_hearts
					@around = 0
				end
				# Store new position of mouse
				@movem[:pkmn] = @oldm.clone
				@time[:pkmn]  = 0
			end
		end

		def update_mouse_feed
			@feed = false if !System.mouse_in_window
			return unless @feed
			if @feedshow
				@feedshow = false
				4.times {
					update_ingame
					@sprites["feedshow"].zoom_y -= 0.2
					# Update icon
					update_zoom_icon_item
					# Clear text
					clearTxt("quantity text")
				}
				8.times {
					update_ingame
					@sprites["feedshow"].zoom_x -= 0.1
				}
				# Reset icon
				update_reset_bitmap
			end
			set_visible_sprite("feedshow")
			file = GameData::Item.icon_filename(@itemName)
			@sprites["mouse"].bitmap = Bitmap.new(file)
			if Input.time?(Input::MOUSELEFT) == 0
				set_sprite("mouse", "hand2")
				@feed = false
				return
			end
			return if !areaMouse?(@sizePkmn)
			@eatCount += 1
			name = @eatCount / 5 + 1
			pbSEPlay("eat.ogg", 90, 100) if @eatCount % 5 == 0
			if name == 3
				set_sprite("mouse", "eaten#{name}")
				# Delete item
				PkmnAR.feed($Trainer.party[@pkmn[:index]], @itemName)
				# Show heart
				update_show_hearts
				# Delete item in @item if it's necessaire
				@item.delete(@itemName) if !$PokemonBag.pbHasItem?(@itemName)
				# Reset
				@eatCount = 0
				@feed = false
			else
				@sprites["mouse"].mask(Bitmap.new("Graphics/Pictures/Pokemon Amie/eaten#{name}"))
			end
		end

		#---------------------#
		# Update: show hearts #
		#---------------------#
		def update_show_hearts
			4.times { |i|
				@sprites["heart #{i}"] = Sprite.new(@viewport) if !@sprites["heart #{i}"]
				set_sprite("heart #{i}", "heart")
				@sprites["heart #{i}"].z = 4
				x = Graphics.width / 2 + rand(70) - 40
				y = Graphics.height / 2 - rand(40) + 30
				set_xy_sprite("heart #{i}", x, y)
				set_visible_sprite("heart #{i}", true)
			}
			# Animation
			set_visible_sprite("mouse")
			GameData::Species.play_cry(@pkmn[:name])
			loop do
				15.times {
					4.times { |i|
						update_ingame
						@sprites["heart #{i}"].x += rand(100) / 10 - rand(100) / 10
						@sprites["heart #{i}"].y -= (rand(4) / 3 + 1) * 3
					}
				}
				break
			end
			4.times { |i| set_visible_sprite("heart #{i}") }
			update_sprites_mouse
			set_sprite("mouse", "hand2")
		end

		#-------------------------#
		# Update graphics pokemon #
		#-------------------------#
		def update_bitmap_pokemon(pos)
			$Trainer.party[@pkmn[:index]] = @pkmn[:name]
			@pkmn[:name]  = $Trainer.party[pos]
			@pkmn[:index] = pos
			pkmn = @pkmn[:name]
			species = pkmn.species
			species = GameData::Species.get(species).species
			file = GameData::Species.front_sprite_filename(species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)
			@sprites["pkmn"].bitmap = Bitmap.new(file)
		end

		def update_visible_pkmn = set_visible_sprite("pkmn", @bg==0)

		def store_size_pkmn
			bitmap = @sprites["pkmn"].bitmap
			x = @sprites["pkmn"].x - @sprites["pkmn"].ox + width_left_right(bitmap)
			y = @sprites["pkmn"].y - @sprites["pkmn"].oy + height_top_bot(bitmap)
			w = width_bitmap(bitmap)
			h = height_bitmap(bitmap)
			@sizePkmn = [x, y, w, h]
		end

		def update_icon_pkmn
			@pkmn[:size].times { |i| set_visible_sprite("icon #{i}", @bg==1) }
			if @bg != 1
				@animated.map! { |a| 0 }
				return
			end
			@pkmn[:party].each_with_index { |can, i|
				next unless can
				next if @frames % 4 != 0
				div = @sprites["icon #{i}"].bitmap.width / @sprites["icon #{i}"].bitmap.height
				@animated[i] += 1
				@animated[i]  = 0 if @animated[i] >= div
				x = @sprites["icon #{i}"].bitmap.height * @animated[i]
				set_src_xy_sprite("icon #{i}", x, 0)
			}
		end

		#------------------#
		# Update icon item #
		#------------------#
		def update_item_fake
			@itemF = []
			@storeItem = []
			return if @item.size <= 0
			max = max_item_show
			max = @item.size > max ? max : @item.size
			(@posItem...(max+@posItem)).each { |i|
				@itemF << @item[i]
				# 48: length of bitmap 'item', 15 is distance between two bitmaps
				x = 80 + 4 + (48 + 15) * (i - @posItem)
				y = @sprites["feed"].y - @sprites["item #{i-@posItem}"].src_rect.height / 2 - 4
				w = 48 - 4 * 2
				h = 48 - 4 * 2
				@storeItem << [x, y, w, h]
			}
		end

		# Use open and close feed bar
		def update_zoom_icon_item(plus=false)
			update_item_fake
			@posItem = 0 if !@feedshow
			return if @itemF.size <= 0
			@itemF.each_with_index { |item, i|
				set_visible_sprite("item #{i}", true)
				if plus
					@sprites["item #{i}"].zoom_x += 0.25
					@sprites["item #{i}"].zoom_y += 0.25
				else
					@sprites["item #{i}"].zoom_x -= 0.25
					@sprites["item #{i}"].zoom_y -= 0.25
				end
			}
		end

		def update_position_icon_item
			update_item_fake
			return if @itemF.size <= 0
			@itemF.each_with_index { |item, i|
				file = GameData::Item.icon_filename(item)
				@sprites["item #{i}"].bitmap = Bitmap.new(file)
				ox = @sprites["item #{i}"].bitmap.width / 2
				x = 80 + ox + (ox * 2 + 15) * i + @storeNItCPL + @storeNItCPR
				y = @sprites["feed"].y
				set_xy_sprite("item #{i}", x, y)
			}
		end

		def update_reset_bitmap
			update_item_fake
			return if @itemF.size <= 0
			# Reset values
			@posItem = 0
			@storeNItCPL = 0
			@storeNItCPR = 0
			# Reset bitmap
			@itemF.each_with_index { |item, i|
				file = GameData::Item.icon_filename(item)
				@sprites["item #{i}"].bitmap = Bitmap.new(file)
			}
		end

		#----------------------#
		# Update icon features #
		#----------------------#
		def update_icon_aff_full_enjoy
			namesprite = ["aff", "full", "enjoy"]
			namefile   = ["affect", "full", "enjoy"]
			3.times { |i|
				5.times { |j|
					set_visible_sprite("#{namesprite[i]} #{j}", @bg==1)
				}
			}
			return if @bg == 0
			3.times { |i|
				level = @pkmn[:name].amie_stats(i)
				5.times { |j|
					x = j + 1 <= level ? @sprites["#{namesprite[i]} #{j}"].src_rect.width : 0
					set_src_xy_sprite("#{namesprite[i]} #{j}", x, 0)
				}
			}
		end

	end
end