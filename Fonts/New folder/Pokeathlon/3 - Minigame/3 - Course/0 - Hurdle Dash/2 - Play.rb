module Pokeathlon
	class Minigame_HurdleDash

		def show
			# Create scene
			create_scene
			# Announcement
			announcement_anim
			loop do
				update_ingame
				@exit = @distance.values.count { |i| i <= @lengthRace } == 0
				if @exit
					# Show rank
					update_number_big
					# Calculate
					calculation_points
					draw_points
					# Set visible
					set_visible_sprite("announ finish", true)
					# Break
					break if checkInput(Input::USE) || checkInput(Input::BACK) || (clickedMouse? && posMouse)
				elsif !@nearfinish.include?(false)
					draw_points(true)
				end
				# Update
				update_main
				# Draw text
				draw_main
				# Click mouse
				click_mouse_pokemon
				@frames += 1
			end
		end

		#--------------#
		# Create scene #
		#--------------#
		def create_scene

			# Create sponsors
			create_sprite("fake sponsors left", "sponsorsleft", @viewport)
			create_sprite("fake sponsors right", "sponsorsright", @viewport)
			@sprites["sponsors left"] = AnimatedPlane.new(@viewport)
			@sprites["sponsors left"].setBitmap("Graphics/Pokeathlon/Minigame/01 - Hurdle Dash/sponsorsleft")
			@sprites["sponsors right"] = AnimatedPlane.new(@viewport)
			@sprites["sponsors right"].setBitmap("Graphics/Pokeathlon/Minigame/01 - Hurdle Dash/sponsorsright")

			create_sprite("bg", "Race", @viewport)
			# Create line
			3.times { |i|
				create_sprite("line #{i}", "Line", @viewport)
				w = @sprites["line #{i}"].bitmap.width / 3
				h = @sprites["line #{i}"].bitmap.height
				set_src_wh_sprite("line #{i}", w, h)
				set_src_xy_sprite("line #{i}", i * w, 0)
			}

			# Shadow (black)
			create_black_shadow(3)

			# Create fence
			create_fence

			# Pokemon
			spe = @pkmn[0..2]
			pkmn_shadow_bitmap(spe)
			xx = 40 + 112 / 2
			yy = Graphics.height - 64 * 2 - 40
			pkmn_shadow_xy(spe, xx, yy, 160)
			pkmn_shadow_src_xy([0, 2], nil, 3)
			spe = @species[0..2]
			# Stun
			create_stun_bitmap(3)
			# Boost
			create_boost(spe)
			# Set x, y (stun, shadow)
			3.times { |i|
				# Shadow
				x = xx + 160 * i
				y = yy + @sprites["pkmn #{i}"].src_rect.height / 2
				set_xy_sprite("black shadow #{i}", x, y)

				# Stun
				x = xx + 160 * i
				y = yy - @sprites["pkmn #{i}"].src_rect.height / 2
				set_xy_sprite("stun #{i}", x, y)
			}

			# Set x, y line
			3.times { |i|
				x = xx + 160 * i - 56
				set_xy_sprite("line #{i}", x, yy)
			}

			# Mini bar
			create_sprite("mini bar", "Mini bar", @viewport)
			# Order (Rank of pokemon)
			3.times { |i|
				# Small
				create_sprite("rank number #{i}", "Number", @viewport)
				w = @sprites["rank number #{i}"].bitmap.width / 12
				h = @sprites["rank number #{i}"].bitmap.height
				set_src_wh_sprite("rank number #{i}", w, h)
				set_src_xy_sprite("rank number #{i}", i * w, 0)
				set_oxoy_sprite("rank number #{i}", w / 2, h / 2)
				x = @store["pkmn #{i}"][0]
				y = @store["pkmn #{i}"][1] + 32 + h
				set_xy_sprite("rank number #{i}", x, y)

				# Big
				create_sprite("rank number big #{i}", "Number big", @viewport)
				w = @sprites["rank number big #{i}"].bitmap.width / 12
				h = @sprites["rank number big #{i}"].bitmap.height
				set_src_wh_sprite("rank number big #{i}", w, h)
				set_src_xy_sprite("rank number big #{i}", i * w, 0)
				set_oxoy_sprite("rank number big #{i}", w / 2, h / 2)
				y = @sprites["mini bar"].bitmap.height + 20 + h / 2
				set_xy_sprite("rank number big #{i}", x, y)
				set_visible_sprite("rank number big #{i}")
			}
			# Mini pokemon
			spe = @pkmn[0..8]
			icon_pkmn_shadow_bitmap(spe)
			x = 64 / 2
			y = 14 + 64 / 2
			disx = 64
			icon_pkmn_shadow_xy(spe, x, y, disx)
			# Text (draw times)
			create_sprite_2("times text", @viewport)
			draw_times

			# Announcement (start)
			announcement

			# Text (total points of player)
			create_sprite_2("total points text", @viewport)
		end

		#--------------#
		# Create boost #
		#--------------#
		def create_boost(pkmn)
			pkmn.size.times { |i|
				create_sprite("boost #{i}", "Boost", @viewport)
				w = @sprites["boost #{i}"].bitmap.width / 2
				h = @sprites["boost #{i}"].bitmap.height / 4
				set_src_wh_sprite("boost #{i}", w, h)
				set_oxoy_sprite("boost #{i}", w / 2, h / 2)
				x = @sprites["pkmn #{i}"].x
				y = @sprites["pkmn #{i}"].y
				set_xy_sprite("boost #{i}", x, y)
				set_visible_sprite("boost #{i}")
			}
		end

		#----------------#
		# Create pokemon #
		#----------------#
		def pkmn_shadow_change_xy(str, disx=0, disy=0)
			super(str, disx, disy)
			x = @sprites["pkmn #{str}"].x
			y = @sprites["pkmn #{str}"].y
			set_xy_sprite("boost #{str}", x, y)
		end

		def pkmn_shadow_reset_xy(str)
			super(str)
			x = @sprites["pkmn #{str}"].x
			y = @sprites["pkmn #{str}"].y
			set_xy_sprite("boost #{str}", x, y)
		end

		#--------------#
		# Create fence #
		#--------------#
		def create_fence
			3.times { |i|
				size = @positionFence[i].size
				@positionFence[i].each_with_index { |fe, j|
					# Fence
					create_sprite("fence #{i} #{size-1-j}", "Fence", @viewport)
					w = @sprites["fence #{i} #{size-1-j}"].bitmap.width
					h = @sprites["fence #{i} #{size-1-j}"].bitmap.height
					x = 40 + 160 * i
					y = Graphics.height - 64 * 2 - 40 - fe
					y = -h if y <= 0
					set_xy_sprite("fence #{i} #{size-1-j}", x, y)

					# Red things
					2.times { |k|
						create_sprite("red things #{i} #{size-1-j} #{k}", "Red thing", @viewport)
						ww = @sprites["red things #{i} #{size-1-j} #{k}"].bitmap.width
						xx = k == 0 ? (x - ww - 8) : (x + w + 8)
						set_xy_sprite("red things #{i} #{size-1-j} #{k}", xx, y)
					}
				}
			}
		end
		
		#-----------------------#
		# Set position of mouse #
		#-----------------------#
		def check_mouse
			w = 64
			h = 64
			values = @distance.values
			if areaMouse?([@store["pkmn 0"][0] - w / 2, @store["pkmn 0"][1] - h / 2, w, h])
				return nil if values[0] > @lengthRace
				return :first
			elsif areaMouse?([@store["pkmn 1"][0] - w / 2, @store["pkmn 1"][1] - h / 2, w, h])
				return nil if values[1] > @lengthRace
				return :second
			elsif areaMouse?([@store["pkmn 2"][0] - w / 2, @store["pkmn 2"][1] - h / 2, w, h])
				return nil if values[2] > @lengthRace
				return :third
			end
		end

		def click_mouse_pokemon
			case update_mouse
			when :no_mouse then return
			else
				num = 
					case update_mouse
					when :first  then 0
					when :second then 1
					when :third  then 2
					else
						nil
					end
				return unless clickedMouse?
				return if num.nil?
				return if @jump[num] > 0
				return if @stun[num]
				@jump[num] = jump_calc(num)
			end
		end

		#------------------#
		# Jump - calculate #
		#------------------#
		def jump_calc(num) = @acceleration * @boost[num] + @oriJump[num]

		#--------------------#
		# Calculation points #
		#--------------------#
		def calculation_points
			return if @calculated

			calcul = []
			@times.each { |t1|
				num = 0
				t1.each_with_index { |t2, i| num += (i == 0 ? t2 * 60 : i == 1 ? t2 : t2 * 0.1) }
				calcul << num
			}

			# Store score of each pokemon
			@scorePersonal = calcul.clone
			
			num = 0
			calcul.each_with_index { |t, i|
				num  = 0 if i % 3 == 0
				num += t
				@scoreSpecial << num if i % 3 == 2
			}

			# Score of this event
			4.times { |i| @scorep[i] = 11500 / @scoreSpecial[i] }
			@scorep.map! { |sc| sc.to_i }

			@calculated = true
		end

	end
end