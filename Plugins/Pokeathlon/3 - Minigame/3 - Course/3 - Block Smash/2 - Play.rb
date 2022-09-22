module Pokeathlon
	class Minigame_BlockSmash

		def show
			# Create scene
			create_scene
			# Draw
			2.times { draw_main }
			# Animated block
			loop do
				update_ingame
				break unless @triggerAdd.include?(true)
				4.times { |i| animated_add_blocks(i) }
			end
			# Announcement
			announcement_anim
			# Reset number
			w = @sprites["announ num"].src_rect.width
			set_src_xy_sprite("announ num", w * 2, 0)
			loop do
				update_ingame
				if @exit
					4.times { |i|
						10.times { |j|
							set_visible_sprite("blocks smashed #{i} #{j}") if @sprites["blocks smashed #{i} #{j}"].visible
							if @sprites["blocks black #{i} #{j}"].visible && @blocks[i][j]
								set_visible_sprite("blocks black #{i} #{j}")
								2.times { |k| set_visible_sprite("#{["crack_big", "crack_small"][k]} #{j}") } if i == 0
							end
						}
					}
					# Draw result text
					result_txt
					# Show result bitmap
					set_visible_sprite("announ finish", true)
					break if checkInput(Input::USE) || checkInput(Input::BACK)
					next
				end
				# Update
				update_main
				# Draw text
				draw_main
				# Click mouse
				click_mouse_pokemon
				# Add frames
				@frames += 1
			end
		end

		#--------------#
		# Create scene #
		#--------------#
		def create_scene
			create_sprite("bg left", "bg_block_smash", @viewport)
			create_sprite("bg right", "top block smash", @viewport)
			xx = Settings::SCREEN_WIDTH
			set_xy_sprite("bg right", xx, 0)

			# Pokemon
			# Right scene #
			# Icon
			pkmn = []
			@pkmn.each_with_index { |pk, i| pkmn << pk if i % 3 == 0 }
			pkmn_shadow_bitmap(pkmn)
			x = 35
			disx = 64 + 50
			y = 82
			pkmn_shadow_xy(pkmn, x, y, disx)
			# Pokemon of player (front bitmap)
			file = front_file_pokemon_play(@pkmn[0])
			@sprites["pkmn 0"].bitmap = Bitmap.new(file)
			h = @sprites["pkmn 0"].bitmap.height
			set_src_wh_sprite("pkmn 0", h, h)
			set_oxoy_sprite("pkmn 0", h / 2, h)
			x = 64 + 396 / 2
			y = 250 + 58 / 2 - 60

			# Store y of pokemon
			@store[:first_y] = y

			set_xy_sprite("pkmn 0", x, y)
			set_zoom_sprite("shadow pkmn 0", 6, 4)
			y += @sprites["shadow pkmn 0"].src_rect.height * @sprites["shadow pkmn 0"].zoom_y / 2
			set_xy_sprite("shadow pkmn 0", x, y)
			@sprites["pkmn 0"].z = 1
			# Left scene #
			# Icon
			pkmn = []
			@pkmn.each_with_index { |pk, i| pkmn << pk if i % 3 == 0 }
			icon_pkmn_shadow_bitmap(pkmn)
			x = 198 + 44 + Settings::SCREEN_WIDTH
			disx = 64
			y = 306
			icon_pkmn_shadow_xy(pkmn, x, y, disx)
			4.times { |i| set_visible_sprite("shadow icon pkmn #{i}") }
			# Pokemon
			2.times {	|i|
				file = front_file_pokemon_play(@pkmn[1+i])
				set_bitmap("pkmn left screen #{1+i}", file, @viewport)
				h = @sprites["pkmn left screen #{1+i}"].bitmap.height
				set_src_wh_sprite("pkmn left screen #{1+i}", h, h)
				set_oxoy_sprite("pkmn left screen #{1+i}", h / 2, h / 2)
				x = 90 + Settings::SCREEN_WIDTH
				y = 270 - 190 * i
				set_xy_sprite("pkmn left screen #{1+i}", x, y)
			}

			# Create tension
			create_boost_bitmap

			# Create smoke, ball
			create_bitmap_when_change_pkmn

			# Block
			# 7 blocks (small) && 1 block (big)
			# 4 blocks (black)
			create_blocks_black
			# 4 blocks (color)
			create_blocks_color

			# Switch icon
			create_switch_icon
			@sprites["switch icon"].color = Color.new(197, 68, 68, 0)

			# Create sweats, stun
			create_sweats(4)
			create_stun_bitmap(4)
			# Change zoom (pokemon 0)
			4.times { |i|
				pkmnx = @sprites["pkmn #{i}"].x
				pkmny = @sprites["pkmn #{i}"].y - @sprites["pkmn #{i}"].src_rect.height / 2
				if i == 0
					zoom = 2
					set_zoom_sprite("sweats #{i}", zoom, zoom)
					@sprites["sweats #{i}"].z = 1
					set_zoom_sprite("stun #{i}", zoom, zoom)
					@sprites["stun #{i}"].z = 1
				end
				set_xy_sprite("sweats #{i}", pkmnx, pkmny)
				set_xy_sprite("stun #{i}", pkmnx, pkmny)
			}

			# Announcement
			announcement
			arr = ["announ num", "announ start", "announ finish"]
			3.times { |i|
				@sprites[arr[i]].x = xx / 2
				@sprites[arr[i]].z = 2
			}

			# Text
			create_sprite_2("time text", @viewport)
			create_sprite_2("pieces text", @viewport)
			create_sprite_2("name pkmn right screen text", @viewport)
			create_sprite_2("total text", @viewport)
			@sprites["total text"].z = 1

			# Store bitmap pokemon (height)
			@store[:bottom_bitmap_pkmn] = []
			sprite = {}
			3.times { |i|
				sprite[i] = Sprite.new(@viewport)
				file = front_file_pokemon_play(@pkmn[i])
				sprite[i].bitmap = Bitmap.new(file)
	
				# Store
				@store[:bottom_bitmap_pkmn] << (sprite[i].src_rect.height - height_top_bot(sprite[i].bitmap, true) + 28)
			}
			pbDisposeSpriteHash(sprite)

			# Modify y
			@sprites["pkmn 0"].y += @store[:bottom_bitmap_pkmn][0]

		end

		#---------------#
		# Create blocks #
		#---------------#
		# Change bitmap at 50%, 25% -> skill (if changed, it doesn't change again if block doesn't smash)
		def create_blocks_black
			@store[:x_cracks] = []
			@store[:y_cracks] = []

			crack = ["crack_big", "crack_small"]
			4.times { |i|
				10.times { |j|
					order = 10 - 1 - j
					create_sprite("blocks black #{i} #{order}", "block", @viewport)
					w = @sprites["blocks black #{i} #{order}"].bitmap.width / 3
					h = @sprites["blocks black #{i} #{order}"].bitmap.height
					set_src_wh_sprite("blocks black #{i} #{order}", w, h)
					
					if i == 0
						@sprites["blocks black #{i} #{order}"].oy = h - 10
						# Blocks
						x = @sprites["pkmn #{i}"].x - 80 - 60 + w / 4
						y = @sprites["pkmn #{i}"].y - 80 + h + 60 + 10 * order
						set_xy_sprite("blocks black #{i} #{order}", x, y)
						@sprites["blocks black #{i} #{order}"].z = 1

						# Cracks
						@store[:x_cracks][j] = []
						@store[:y_cracks][j] = []
						2.times { |k|
							create_sprite("#{crack[k]} #{order}", crack[k], @viewport)
							w = @sprites["#{crack[k]} #{order}"].bitmap.width
							h = @sprites["#{crack[k]} #{order}"].bitmap.height
							randomx = rand(50)
							randomy = rand(46)
							y = @sprites["blocks black #{i} #{order}"].y - 12 - randomy
							x = @sprites["blocks black #{i} #{order}"].x + 38 + randomx

							@store[:x_cracks][j] << x
							@store[:y_cracks][j] << y

							set_xy_sprite("#{crack[k]} #{order}", x, y)
							set_visible_sprite("#{crack[k]} #{order}")

							@sprites["#{crack[k]} #{order}"].z = 1
						}
					else
						set_oxoy_sprite("blocks black #{i} #{order}", w / 2, h / 2)
						zoom = 0.5
						set_zoom_sprite("blocks black #{i} #{order}", zoom, zoom)
						x = @sprites["pkmn #{i}"].x - 64 + 26 + w / 4 * zoom
						y = @sprites["pkmn #{i}"].y + 14 + (10 / 2) * order
						set_xy_sprite("blocks black #{i} #{order}", x, y)
					end

					set_visible_sprite("blocks black #{i} #{order}")

					# Blocks crashed
					create_sprite("blocks smashed #{i} #{order}", "Crashed block", @viewport)
					w = @sprites["blocks smashed #{i} #{order}"].bitmap.width
					h = @sprites["blocks smashed #{i} #{order}"].bitmap.height
					set_oxoy_sprite("blocks smashed #{i} #{order}", w / 2, h / 2)
					if i == 0
						x = @sprites["blocks black #{i} #{order}"].x + @sprites["blocks black #{i} #{order}"].src_rect.width / 2
						y = @sprites["blocks black #{i} #{order}"].y - (@sprites["blocks black #{i} #{order}"].src_rect.height / 2 - 10)
						set_xy_sprite("blocks smashed #{i} #{order}", x, y)

						@sprites["blocks smashed #{i} #{order}"].z = 1
					else
						set_zoom_sprite("blocks smashed #{i} #{order}", zoom, zoom)

						x = @sprites["blocks black #{i} #{order}"].x
						y = @sprites["blocks black #{i} #{order}"].y
						set_xy_sprite("blocks smashed #{i} #{order}", x, y)
					end
					
					set_visible_sprite("blocks smashed #{i} #{order}")
				}
				@triggerAdd[i] = true
			}
		end

		def create_blocks_color
			4.times { |i|
				2.times { |j|
					10.times { |k|
						create_sprite("blocks color #{i} #{1-j} #{k}", "color blocks", @viewport)
						w = @sprites["blocks color #{i} #{1-j} #{k}"].bitmap.width / 4
						h = @sprites["blocks color #{i} #{1-j} #{k}"].bitmap.height
						set_src_wh_sprite("blocks color #{i} #{1-j} #{k}", w, h)
						set_src_xy_sprite("blocks color #{i} #{1-j} #{k}", i * w, 0)
						@sprites["blocks color #{i} #{1-j} #{k}"].oy = h - 10
						x = 198 + 44 + Settings::SCREEN_WIDTH - w / 2 + 8 + 64 * i + 12 * (1 - j)
						y = 306 - 40 - 10 * k - (h - 10) * (1 - j)
						set_xy_sprite("blocks color #{i} #{1-j} #{k}", x, y)
						set_visible_sprite("blocks color #{i} #{1-j} #{k}")
					}
				}
			}
		end

		#--------------------#
		# Create smoke, ball #
		#--------------------#
		def create_bitmap_when_change_pkmn
			4.times { |i|
				# Smoke
				create_sprite("smoke #{i}", "Smoke", @viewport)
				w = @sprites["smoke #{i}"].bitmap.width / 3
				h = @sprites["smoke #{i}"].bitmap.height
				set_src_wh_sprite("smoke #{i}", w, h)
				set_oxoy_sprite("smoke #{i}", w / 2, h / 2)
				if i > 0
					zoom = 0.5
					set_zoom_sprite("smoke #{i}", zoom, zoom)
				end
				x = @sprites["pkmn #{i}"].x
				y = @sprites["pkmn #{i}"].y
				set_xy_sprite("smoke #{i}", x, y)
				set_visible_sprite("smoke #{i}")

				@sprites["smoke #{i}"].z = 1 if i == 0

				# Pokeball
				create_sprite("ball icon #{i}", "POKEBALL", @viewport)
				ox = @sprites["ball icon #{i}"].bitmap.width / 2
				oy = @sprites["ball icon #{i}"].bitmap.height / 2
				set_oxoy_sprite("ball icon #{i}", ox, oy)
				x = @sprites["icon pkmn #{i}"].x
				y = @sprites["icon pkmn #{i}"].y
				set_xy_sprite("ball icon #{i}", x, y)
				set_visible_sprite("ball icon #{i}")
			}
		end

		#------------------------#
		# Create boost (Tension) #
		#------------------------#
		def create_boost_bitmap
			4.times { |i|
				create_sprite("tension #{i}", "Tension", @viewport)
				w = @sprites["tension #{i}"].bitmap.width / 2
				h = @sprites["tension #{i}"].bitmap.height / 2
				set_src_wh_sprite("tension #{i}", w, h)
				set_oxoy_sprite("tension #{i}", w / 2, h / 2)
				if i == 0
					@sprites["tension #{i}"].z = 1
				else
					zoom = 0.5
					set_zoom_sprite("tension #{i}", zoom, zoom)
				end
				x = @sprites["shadow pkmn #{i}"].x
				y = @sprites["shadow pkmn #{i}"].y
				set_xy_sprite("tension #{i}", x, y)
				set_visible_sprite("tension #{i}")
			}
		end

		#----------#
		# Animated #
		#----------#
		def animated_add_blocks(num, reset=false)
			return unless @triggerAdd[num]
			col = @waitAdd[num].collect { |w| w > 0 }
			crack = ["crack_big", "crack_small"]
			@waitAdd[num].each_with_index { |w, i|
				next if w > 0 || @sprites["blocks black #{num} #{i}"].visible
				@sprites["blocks black #{num} #{i}"].src_rect.x = 0
				set_visible_sprite("blocks black #{num} #{i}", true)
				2.times { |j| set_visible_sprite("#{crack[j]} #{i}", true) } if num == 0
			}
			if col.include?(true)
				i = col.rindex(true)
				@waitAdd[num][i] -= 1
			else
				@sprites["switch icon"].src_rect.x = 0 if num == 0

				@triggerAdd[num] = false
				@waitAdd[num].map! { @store[:wait_add] }

				# Reset use in case, player is playing
				if reset

					@blocksHP[num].map! { 100 }
					@blocks[num].map! { false }
					@smashBlock[num].map! { @store[:wait_show_smashed_block] }

					# Position of block smashes
					@posBlockSmash[num] = 0

				end

			end
		end

		#----------------#
		# Set x, y crack #
		#----------------#
		# Use with first pokemon
		# Use in update
		def set_xy_cracks
			crack = ["crack_big", "crack_small"]
			2.times { |i|
				10.times { |j|

					@store[:x_cracks][j] = []
					@store[:y_cracks][j] = []
	
					randomx = rand(50)
					randomy = rand(46)
					y = @sprites["blocks black #{i} #{j}"].y - 12 - randomy
					x = @sprites["blocks black #{i} #{j}"].x + 38 + randomx

					@store[:x_cracks][j] << x
					@store[:y_cracks][j] << y

					set_xy_sprite("#{crack[i]} #{j}", x, y)
				}
			}
		end

		#-------#
		# Mouse #
		#-------#
		def check_mouse
			return :switch if areaMouse?([@sprites["switch icon"].x, @sprites["switch icon"].y, @sprites["switch icon"].src_rect.width, @sprites["switch icon"].src_rect.height])
			return nil if @triggerAdd[0]
			pos = @posBlockSmash[0]

			# Cracks
			crack = ["crack_big", "crack_small"]
			2.times { |i|
				w = @sprites["#{crack[i]} #{pos}"].bitmap.width
				h = @sprites["#{crack[i]} #{pos}"].bitmap.height
				x1 = @store[:x_cracks][pos][0]
				y1 = @store[:y_cracks][pos][0]
				x2 = @store[:x_cracks][pos][1]
				y2 = @store[:y_cracks][pos][1]
				return :crack if areaMouse?([x1, y1, w, h]) || areaMouse?([x2, y2, w, h])
			}

			# Blocks
			return nil if pos.nil?
			w = @sprites["blocks black 0 #{pos}"].src_rect.width
			h = @sprites["blocks black 0 #{pos}"].src_rect.height
			x = @sprites["blocks black 0 #{pos}"].x
			y = @sprites["blocks black 0 #{pos}"].y - (h - 10)
			h -= 10
			return :block if areaMouse?([x, y, w, h])
			return nil
		end

		def click_mouse_pokemon
			value = update_mouse
			case value
			when :no_mouse, nil then return
			else
				# Click mouse
				return unless clickedMouse?
				# Add new blocks
				return if @triggerAdd[0]
				# Switch
				return if @triggerChange[0]
				# Stun
				return if @stun[0]

				case value
				when :block, :crack then blocks_smash_value(0, value == :crack)
				# Trigger to show animated and change pokemon
				when :switch then @triggerChange[0] = true
				end

			end
		end

		# Blocks smash (cracks)
		def blocks_smash_value(num, crack=false)
			pos = @posBlockSmash[num]

			if crack
				@gotCracks[num] += 1
				index = @quantCracks.index(@gotCracks[num])
				if index
					@boost[num] = index + 1
					@timeBoostParty[num] = @timeBoost[index].clone
				end
			end

			if @boost[num] > 0
				@timeBoostParty[num] += 1 if crack

				newpos = 0
				@smashImmediately[@boost[num]-1].times { |i|
					newpos = pos + i
					break if newpos >= 10
					# Record points
					@scorep[num] += 1 # In this game, @scorep = @scoreSpecial
					@scoreSpecial[num] += 1
					@scorePersonal[@orderPkmn[num][:position][0]] += 1

					# Decrease stamina
					@orderPkmn[num][:stamina][0] -= @orderPkmn[num][:power][0] if @boost[num] < 2

					@blocksHP[num][newpos] = 0
					@blocks[num][newpos] = true
				}
				pos = newpos >= 10 ? 9 : newpos
			else
				# Decrease stamina
				@orderPkmn[num][:stamina][0] -= @orderPkmn[num][:power][0]  if @boost[num] < 2

				@blocksHP[num][pos] -= 1.0 / @orderPkmn[num][:skill][0] * 100
				if @blocksHP[num][pos] <= 0
					@blocks[num][pos] = true

					# Record points
					@scorep[num] += 1 # In this game, @scorep = @scoreSpecial
					@scoreSpecial[num] += 1
					@scorePersonal[@orderPkmn[num][:position][0]] += 1
				end
			end

			# Limit (scores)
			@scorep[num] = 200 if @scorep[num] > 200
			@scoreSpecial[num] = 200 if @scoreSpecial[num] > 200

			@posBlockSmash[num] = pos

			# Show icons (right screen)
			number = @scoreSpecial[num] / 10
			@blocksIcon[num].map!.with_index { |_, i| i + 1 <= number }
			
			# After that, show animated, reset @blocks
			if @blocksHP[num][pos] <= 0
				pos == 9 ? (@triggerAdd[num] = true) : (@posBlockSmash[num] += 1)
			end
			
			# Sweats / Stun
			if @orderPkmn[num][:stamina][0] <= 0
				@orderPkmn[num][:stamina][0] = 0
				@stun[num] = true
				@missp[@orderPkmn[num][:position][0]] += 1
			end
		end

		#----------------#
		# Switch pokemon #
		#----------------#
		def switch_values(num)
			2.times { |i|
				@orderPkmn[num].each { |k, _| @orderPkmn[num][k][i], @orderPkmn[num][k][i+1] = @orderPkmn[num][k][i+1], @orderPkmn[num][k][i] }
			}
		end

	end
end