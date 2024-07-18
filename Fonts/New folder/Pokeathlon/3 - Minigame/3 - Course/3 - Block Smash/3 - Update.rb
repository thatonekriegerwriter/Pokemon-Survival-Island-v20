module Pokeathlon
	class Minigame_BlockSmash

		def update_main
			# Value
			update_times
			update_auto
			update_stun

			# Bitmap
			update_boost
			update_all_bitmap
			update_animated_pkmn
		end

		# Update times
		def update_times
			@second -= 1
			return if @second > 0
			if @times.between?(0, 3)
				w = @sprites["announ num"].src_rect.width
				set_src_xy_sprite("announ num", w * (@times - 1), 0)
				set_visible_sprite("announ num", true)
			end
			if @times - 1 < 0
				@exit = true
				return
			end
			@times -= 1
			@second = @betweenT
		end

		# Update:
		# Decrease number of cracks (pokemon hits)
		# Decrease Tension (@boost)
		# Recover stamina (in case: pokemon changed)
		def update_auto
			4.times { |i|

				# Recover stamina
				@orderPkmn[i][:stamina].each_with_index { |sta, j|
					next if j == 0
					origin = @oriStamina[@orderPkmn[i][:position][j]]
					if sta > origin
						@orderPkmn[i][:stamina][j] = origin
					elsif sta < origin
						next if @frames % 2 == 0
						@orderPkmn[i][:stamina][j] += 2
						@orderPkmn[i][:stamina][j]  = origin if @orderPkmn[i][:stamina][j] > origin
					end
				}
				
				# Decrease cracks
				if @frames % 6 == 0
					@gotCracks[i] -= 1
					@gotCracks[i]  = 0 if @gotCracks[i] < 0
				end

				# Decrease Tension
				if @frames % 4 == 0
					@timeBoostParty[i] -= 1
					if @timeBoostParty[i] < 0
						@timeBoostParty[i] = 0
						@boost[i] = 0
					end
				end
			}
		end

		#---------------------------#
		# Update pokemon (animated) #
		#---------------------------#
		def update_animated_pkmn
			return if @frames % 4 != 0
			4.times { |i|
				w = @sprites["pkmn #{i}"].src_rect.width
				wmax = @sprites["pkmn #{i}"].bitmap.width
				@sprites["pkmn #{i}"].src_rect.x += w
				@sprites["pkmn #{i}"].src_rect.x  = 0 if @sprites["pkmn #{i}"].src_rect.x >= wmax
			}
		end

		#-------------#
		# Update stun #
		#-------------#
		def update_stun
			4.times { |i|
				next unless @stun[i]
				# Bitmap
				if @sprites["sweats #{i}"].visible
					set_visible_sprite("sweats #{i}")
					@sprites["sweats #{i}"].src_rect.x = 0
				end
				w = @sprites["stun #{i}"].src_rect.width
				wmax = @sprites["stun #{i}"].bitmap.width
				@sprites["stun #{i}"].src_rect.x += w
				@sprites["stun #{i}"].src_rect.x  = 0 if @sprites["stun #{i}"].src_rect.x >= wmax
				set_visible_sprite("stun #{i}", true) if !@sprites["stun #{i}"].visible
				
				@timeStun[i] -= 1
				if @timeStun[i] < 0
					@timeStun[i] = @store[:time_stun]
					@stun[i] = false
					# Recover (10% after stunning)
					rate = 10 / 100.0 * @oriStamina[@orderPkmn[i][:position][0]]
					@orderPkmn[i][:stamina][0] += rate.to_i

					# Bitmap
					@sprites["stun #{i}"].src_rect.x = 0
					set_visible_sprite("stun #{i}")
					set_visible_sprite("sweats #{i}", true)
				end
			}
		end

		#--------------#
		# Update boost #
		#--------------#
		def update_boost
			4.times { |i|
				if @boost[i] == 0
					set_visible_sprite("tension #{i}") if @sprites["tension #{i}"].visible
					next
				end
				set_visible_sprite("tension #{i}", true) if !@sprites["tension #{i}"].visible
				h = @sprites["tension #{i}"].src_rect.height
				@sprites["tension #{i}"].src_rect.y = h * (@boost[i] - 1) 
				next if @frames % 4 != 0
				w = @sprites["tension #{i}"].src_rect.width
				wmax = @sprites["tension #{i}"].bitmap.width
				@sprites["tension #{i}"].src_rect.x += w
				@sprites["tension #{i}"].src_rect.x  = 0 if @sprites["tension #{i}"].src_rect.x >= wmax
			}
		end

		#--------------------------------#
		# Update bitmap (can't separate) #
		#--------------------------------#
		def update_all_bitmap
			crack = ["crack_big", "crack_small"]
			4.times { |i|
				# Stun
				if @stun[i]
					10.times { |j| set_visible_sprite("blocks smashed #{i} #{j}") if @sprites["blocks smashed #{i} #{j}"].visible }
					if i == 0
						@sprites["switch icon"].src_rect.x = @sprites["switch icon"].src_rect.width
						@sprites["switch icon"].color.alpha = 0
					end
					next
				end

				# Sweats
				quart = 25 / 100.0 * @oriStamina[@orderPkmn[i][:position][0]]
				stamina = @orderPkmn[i][:stamina][0].clone
				if stamina <= quart
					set_visible_sprite("sweats #{i}", true) if !@sprites["sweats #{i}"].visible

					if @frames % 4 == 0
						w = @sprites["sweats #{i}"].src_rect.width
						wmax = @sprites["sweats #{i}"].bitmap.width
						@sprites["sweats #{i}"].src_rect.x += w
						@sprites["sweats #{i}"].src_rect.x  = 0 if @sprites["sweats #{i}"].src_rect.x >= wmax
					end

					# Update switch
					if i == 0
						@sprites["switch icon"].src_rect.x = 0
						@sprites["switch icon"].color.alpha = 150
					end
				else
					set_visible_sprite("sweats #{i}") if @sprites["sweats #{i}"].visible
					if i == 0
						if @sprites["switch icon"].color.alpha > 0
							@sprites["switch icon"].src_rect.x = 0
							@sprites["switch icon"].color.alpha = 0
						end
					end
				end

				# Animation (add blocks)
				count = @smashBlock[i].count { |s| s > 0 } == 0
				if @triggerAdd[i] && count
					# Not visible
					10.times { |j| set_visible_sprite("blocks smashed #{i} #{j}") if @sprites["blocks smashed #{i} #{j}"].visible }
					# Cant use switch
					if i == 0
						@sprites["switch icon"].src_rect.x = @sprites["switch icon"].src_rect.width
						@sprites["switch icon"].color.alpha = 0
					end

					animated_add_blocks(i, true)
					next
				end

				# Switch
				if @triggerChange[i]
					# Invisible
					set_visible_sprite("sweats #{i}") if @sprites["sweats #{i}"].visible

					if @waitChange[i] > 0
						if !@sprites["smoke #{i}"].visible
							set_visible_sprite("smoke #{i}", true)
							set_visible_sprite("ball icon #{i}", true)
							set_visible_sprite("icon pkmn #{i}")

							set_visible_sprite("pkmn #{i}")
						end

						@waitChange[i] -= 1
						if @waitChange[i] % 2 == 0
							w = @sprites["smoke #{i}"].src_rect.width
							wmax = @sprites["smoke #{i}"].bitmap.width
							@sprites["smoke #{i}"].src_rect.x += w
							@sprites["smoke #{i}"].src_rect.x  = 0 if @sprites["smoke #{i}"].src_rect.x >= wmax
						end

						next
					else
						# Switch
						switch_values(i)

						# Update pokemon
						if i == 0
							3.times { |j|
								file = front_file_pokemon_play(@orderPkmn[i][:pkmn][j])
								if j == 0
									@sprites["pkmn #{i}"].bitmap = Bitmap.new(file)
									h = @sprites["pkmn #{j}"].bitmap.height
									set_src_wh_sprite("pkmn #{i}", h, h)

									# Modify y
									@sprites["pkmn #{i}"].y = @store[:first_y] + @store[:bottom_bitmap_pkmn][@orderPkmn[i][:position][j]]
									
								else
									@sprites["pkmn left screen #{j}"].bitmap = Bitmap.new(file)
									h = @sprites["pkmn left screen #{j}"].bitmap.height
									set_src_wh_sprite("pkmn left screen #{j}", h, h)
								end
							}
						else
							file = file_pokemon_play(@orderPkmn[i][:pkmn][0])
							@sprites["pkmn #{i}"].bitmap = Bitmap.new(file)
							w = @sprites["pkmn #{i}"].bitmap.width / 4
							h = @sprites["pkmn #{i}"].bitmap.height / 4
							set_src_wh_sprite("pkmn #{i}", w, h)
						end
						file = GameData::Species.icon_filename_from_pokemon(@orderPkmn[i][:pkmn][0])
						@sprites["icon pkmn #{i}"].bitmap = Bitmap.new(file)
						@sprites["icon pkmn #{i}"].src_rect.width = @sprites["icon pkmn #{i}"].bitmap.width / 2

						# Bitmap
						if @sprites["smoke #{i}"].visible
							set_visible_sprite("smoke #{i}")
							set_visible_sprite("ball icon #{i}")
							set_visible_sprite("icon pkmn #{i}", true)

							set_visible_sprite("pkmn #{i}", true)
						end
						@sprites["smoke #{i}"].src_rect.x = 0

						# Reset switch icon
						if i == 0
							@sprites["switch icon"].src_rect.x = 0
							@sprites["switch icon"].color.alpha = 0 if !@sprites["sweats #{i}"].visible
						end

						@waitChange[i] = @store[:wait_change]
						@triggerChange[i] = false
					end
				end

				10.times { |j|

					# Update blocks before blocks break
					num = @blocksHP[i][j] <= 30 ? 2 : @blocksHP[i][j].between?(31, 60) ? 1 : 0
					@sprites["blocks black #{i} #{j}"].src_rect.x = num * @sprites["blocks black #{i} #{j}"].src_rect.width

					# Block smashes
					if @blocks[i][j]
						
						if @smashBlock[i][j] > 0
							@smashBlock[i][j] -= 1
							set_visible_sprite("blocks smashed #{i} #{j}", true) if !@sprites["blocks smashed #{i} #{j}"].visible
						else
							set_visible_sprite("blocks smashed #{i} #{j}")
						end
						if @sprites["blocks black #{i} #{j}"].visible
							set_visible_sprite("blocks black #{i} #{j}")
							2.times { |k| set_visible_sprite("#{crack[k]} #{j}") } if i == 0
						end

					else
						if !@sprites["blocks black #{i} #{j}"].visible
							set_visible_sprite("blocks black #{i} #{j}", true)
							2.times { |k| set_visible_sprite("#{crack[k]} #{j}", true) } if i == 0
						end
					end

					# Show icon block (right screen)
					if @scoreSpecial[i] > 100
						visible = @blocksIcon[i][10+j]
						set_visible_sprite("blocks color #{i} 0 #{j}", visible)
						set_visible_sprite("blocks color #{i} 1 #{j}", true)
					else
						visible = @blocksIcon[i][j]
						set_visible_sprite("blocks color #{i} 0 #{j}", visible)
					end
					
				}
				
				# AI choice
				next if i == 0
				next if @frames % 4 != 0
				next if @stun[i]
				#  <= 25% * stamina
				if stamina <= quart
					# 40% - switch
					switch = rand(10) <= 3
					if switch
						@triggerChange[i] = true
						next
					end
				end
				# 10% - tap cracks
				crack = rand(10) == 0
				blocks_smash_value(i, crack)
			}
		end

	end
end