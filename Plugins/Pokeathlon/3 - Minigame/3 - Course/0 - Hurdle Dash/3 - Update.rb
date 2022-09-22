module Pokeathlon
	class Minigame_HurdleDash

		def update_main
			# Variable
			update_total_frames
			update_jump_variable
			update_number_rank
			update_run
			update_stun

			# Fence
			update_fence_graphics
			# Mini pokemon
			update_mini_pkmn_graphics
			# Pokemon
			update_pkmn_graphics
			# Boost
			update_boost
		end

		#----------#
		# Sponsors #
		#----------#
		def update_sponsors(speed=0, right=false)
			right ? (@sprites["sponsors left"].oy -= speed) : (@sprites["sponsors right"].oy -= speed)
		end

		#------------------#
		# Fence (graphics) #
		#------------------#
		def update_fence_graphics
			3.times { |i|
				# Fence
				@positionFence[i].each_with_index { |fe, j|
					next if fe < - (64 * 2 + 40) - @sprites["fence #{i} #{j}"].bitmap.height
					# Fence crashed
					set_sprite("fence #{i} #{j}", "Fence Crash") if @crashed[i][j]
					y = Graphics.height - 64 * 2 - 40 - fe
					@sprites["fence #{i} #{j}"].y = y
					# Red things
					2.times { |k| @sprites["red things #{i} #{j} #{k}"].y = y }
				}
			}
		end

		#-------#
		# Boost #
		#-------#
		def update_boost
			3.times { |i|
				if @distance[@pkmn[i]] > @lengthRace
					set_visible_sprite("boost #{i}")
					next
				end
				set_visible_sprite("boost #{i}", @boost[i] > 0)
				next if @boost[i] == 0
				next if @frames % 8 == 0
				w = @sprites["boost #{i}"].src_rect.width
				if @sprites["boost #{i}"].src_rect.x + w >= @sprites["boost #{i}"].bitmap.width
					@sprites["boost #{i}"].src_rect.x = 0
				else
					@sprites["boost #{i}"].src_rect.x += w
				end
				@sprites["boost #{i}"].src_rect.y = @sprites["boost #{i}"].src_rect.height * (@boost[i] - 1)
			}
		end

		#--------------------#
		# Pokemon (graphics) #
		#--------------------#
		def update_mini_pkmn_graphics
			# Update species / rank
			sort = sort_rank(@distance)
			if @rank != sort
				@rank = sort
				@redrawmini = true
			end

			8.times { |i|

				# Redraw
				if @redrawmini
					# Pokemon (icon)
					file = GameData::Species.icon_filename_from_pokemon(@rank[i])
					@sprites["icon pkmn #{i}"].bitmap = Bitmap.new(file)
					@sprites["icon pkmn #{i}"].src_rect.width = @sprites["icon pkmn #{i}"].bitmap.width / 2
					# Shadow
					w = @sprites["shadow icon pkmn #{i}"].src_rect.width
					mul = @pkmn.index(@rank[i]) / 3
					set_src_xy_sprite("shadow icon pkmn #{i}", mul * w, 0)
				end

				# Animated
				if @frames % 4 == 0
					w = @sprites["icon pkmn #{i}"].src_rect.width
					if @sprites["icon pkmn #{i}"].src_rect.x + w >= @sprites["icon pkmn #{i}"].bitmap.width
						@sprites["icon pkmn #{i}"].src_rect.x = 0
					else
						@sprites["icon pkmn #{i}"].src_rect.x += w
					end
				end

			}

			@redrawmini = false if @redrawmini
		end

		def update_pkmn_graphics
			3.times { |i|

				# Jump
				if @jump[i] > 0
					pkmn_shadow_change_xy(i, 0, -10) if !@jumped[i]
					@jumped[i] = true
				else
					pkmn_shadow_reset_xy(i) if @jumped[i]
					@jumped[i] = false
				end

				# Animated
				if @frames % 4 == 0
					w = @sprites["pkmn #{i}"].src_rect.width
					if @sprites["pkmn #{i}"].src_rect.x + w >= @sprites["pkmn #{i}"].bitmap.width
						@sprites["pkmn #{i}"].src_rect.x = 0
					else
						@sprites["pkmn #{i}"].src_rect.x += w
					end
				end

			}
		end

		#-----------------------------------#
		# Update: Show number below pokemon #
		#-----------------------------------#
		def update_number_rank
			3.times { |i|
				x = @rank.index(@pkmn[i]) * @sprites["rank number #{i}"].src_rect.width
				set_src_xy_sprite("rank number #{i}", x, 0)
			}
		end
		
		#--------------------------------------#
		# Show number (big) when race finished #
		#--------------------------------------#
		def update_number_big
			3.times { |i|
				set_visible_sprite("rank number #{i}")
				# Set big
				w = @sprites["rank number big #{i}"].src_rect.width
				num = @rank.index(@pkmn[i])
				@sprites["rank number big #{i}"].src_rect.x = num * w
				set_visible_sprite("rank number big #{i}", true)
			}
		end

		#----------------------#
		# Update jump -> @jump #
		#----------------------#
		def update_jump_variable
			@jump.each_with_index { |ju, i|
				next if ju == 0
				@jump[i] -= @oriSpeed[i]
				@jump[i]  = 0 if @jump[i] < 0
			}
		end

		#------------------------#
		# Update: Stun (pokemon) #
		#------------------------#
		def update_stun
			@stun.each_with_index { |st, i|
				next unless st
				@timesStun[i] -= 1

				# Update: graphics - Pokemon
				if i.between?(0, 2) && @frames % 4  == 0
					@sprites["pkmn #{i}"].src_rect.y += @sprites["pkmn #{i}"].src_rect.height
					@sprites["pkmn #{i}"].src_rect.y  = 0 if @sprites["pkmn #{i}"].src_rect.y >= @sprites["pkmn #{i}"].bitmap.height

					set_visible_sprite("stun #{i}", true) if !@sprites["stun #{i}"].visible
					@sprites["stun #{i}"].src_rect.x += @sprites["stun #{i}"].src_rect.width
					@sprites["stun #{i}"].src_rect.x  = 0 if @sprites["stun #{i}"].src_rect.x >= @sprites["stun #{i}"].bitmap.width
				end

				next if @timesStun[i] > 0
				@timesStun[i] = 0
				@stun[i] = false
				
				if i.between?(0, 2)
					# Reset: graphics - Pokemon
					@sprites["pkmn #{i}"].src_rect.y = @sprites["pkmn #{i}"].src_rect.height * 3

					# Reset: graphic - stun
					@sprites["stun #{i}"].src_rect.x = 0
					set_visible_sprite("stun #{i}")
				end
			}
		end

		#---------------------#
		# Update: total times #
		#---------------------#
		def update_total_frames
			return unless @frames % (Graphics.frame_rate / 4) == 0 && @frames > 0
			@totaltimes[2] += 1
			return if @totaltimes[2] < 10
			@totaltimes[2]  = 0
			@totaltimes[1] += 1
			return if @totaltimes[1] < 60
			@totaltimes[1]  = 0
			@totaltimes[0] += 1
		end

		#-------------#		
		# Update: run #
		#-------------#
		# Number (numeric)
		def update_run
			12.times { |i|
				# Stun
				next if @stun[i]

				# Speed
				speed = @acceleration * @boost[i] + @oriSpeed[i]
				speed = @distance[@pkmn[i]] <= @lengthRace ? speed : 10
				# Position
				position = Graphics.height - 64 * 2 - 40
				# Check nearest fence
				near = @positionFence[i].detect { |fe| fe >= 0}
				# Store index of nearest fence
				index = @positionFence[i].index(near)
				# Set again: line
				if i < 3 && !@setLine[i] && @positionFence[i].last <= position + @emptyFinish
					# Update bitmap
					set_sprite("line #{i}", "finish")
					@sprites["line #{i}"].src_rect.width = @sprites["line #{i}"].bitmap.width
					# Update y
					@sprites["line #{i}"].y = position - (@lengthRace - @distance[@pkmn[i]])
					@setLine[i] = true
				end

				# Store times
				if @distance[@pkmn[i]] <= @lengthRace
					@times[i] = @totaltimes.clone
				else
					@nearfinish[i] = true if i < 3
				end

				if near.nil?
					# Pokemon is moving
					@distance[@pkmn[i]] += speed
					# Move: fence
					@positionFence[i].map! { |pos| pos -= speed }
					# Move: bitmap
					next if i > 2

					update_sponsors(speed) if i == 0
					update_sponsors(speed, true) if i == 2

					# Move: start line
					next if @sprites["line #{i}"].y > Graphics.height
					@sprites["line #{i}"].y += speed
					next
				end

				# Check: Pokemon is jumping
				# @positionFence[i][index] - speed = distance: pokemon + @emptyStart
				if @positionFence[i][index] - speed <= 0

					# AI (jump or not) - it depends stat 'Skill' of pokemon
					if i > 2
						random = rand(100)
						num = @oriSkill[i]
						@jump[i] = jump_calc(i) if random <= num
					end

					# Not jump
					if @jump[i] == 0

						# Fence: crash
						if !@passed[i][index]

							# Stun
							@stun[i] = true
							# Stun (times)
							@timesStun[i] = NUMBER_STUN * 2

							# Fence crashed
							@crashed[i][index] = true

							# Pass
							@passed[i][index] = true
							# Not boost
							@boost[i] = 0

							# Store miss
							@missp[i] += 1

						# Move if fence crashed
						else

							# Move
							@distance[@pkmn[i]] += speed
							# Move: fence
							@positionFence[i].map! { |pos| pos -= speed }
							# Move: bitmap
							next if i > 2

							update_sponsors(speed) if i == 0
							update_sponsors(speed, true) if i == 2

							# Move: start line
							next if @sprites["line #{i}"].y > Graphics.height
							@sprites["line #{i}"].y += speed

						end

					# Jump
					else

						# Boost
						if near <= speed + 5
							random = rand(100)
							if random < @oriSkill[i]
								@boost[i] += 1
								@boost[i]  = 4 if @boost[i] > 4
							end
							# Update: speed
							speed = @acceleration * @boost[i] + @oriSpeed[i]
						end

						# Move
						@distance[@pkmn[i]] += speed
						@passed[i][index] = true
						# Move: fence
						@positionFence[i].map! { |pos| pos -= speed }
						# Move: bitmap
						next if i > 2

						update_sponsors(speed) if i == 0
						update_sponsors(speed, true) if i == 2

						# Move: start line
						next if @sprites["line #{i}"].y > Graphics.height
						@sprites["line #{i}"].y += speed

					end

				else

					# Move if pokemon isn't near fence
					@distance[@pkmn[i]] += speed
					# Move: fence
					@positionFence[i].map! { |pos| pos -= speed }
					# Move: bitmap
					next if i > 2

					update_sponsors(speed) if i == 0
					update_sponsors(speed, true) if i == 2

					# Move: start line
					next if @sprites["line #{i}"].y > Graphics.height
					@sprites["line #{i}"].y += speed

				end
			}
		end

	end
end