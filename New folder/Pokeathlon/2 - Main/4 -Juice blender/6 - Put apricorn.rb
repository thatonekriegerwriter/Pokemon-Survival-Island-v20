module Pokeathlon
	class JuiceBlender

		#---------------------#
		# Put apricorn to mix #
		#---------------------#
		def choose_feature_0_choose_1
			return if @choose != 1
			arr = []
			@apricorn.each { |i| arr << "#{GameData::Item.get(i).real_name} x #{$PokemonBag.pbQuantity(i)}" }
			arr << "Cancel"
			file = GameData::Item.icon_filename(@apricorn[0])
			ret  = 0
			# Choice
			create_mess_window(arr)
			# Image
			if !@sprites["apricorn"]
				@sprites["apricorn"] = PictureWindow.new(file)
				@sprites["apricorn"].viewport = @viewport
			end
			@sprites["apricorn"].setBitmap(file)
			@sprites["apricorn"].x = @sprites["cmdwindow"].width
			set_visible_sprite("apricorn", true)
			# Left (apricorn can put)
			if !@sprites["left apricorn"]
				leftapri = $PokemonGlobal.apricorn_juice_chose_first ? (MAX_LIMIT_MIXED - $PokemonGlobal.apricorn_juice_put) : (5 - $PokemonGlobal.apricorn_juice_first.size)
				@sprites["left apricorn"] = Window_AdvancedTextPokemon.new(_INTL("Left:\n<ar>{1}</ar>", leftapri))
				@sprites["left apricorn"].resizeToFit(@sprites["left apricorn"].text, 200)
				x = Graphics.width - @sprites["left apricorn"].width
				set_xy_sprite("left apricorn", x, 0)
				@sprites["left apricorn"].viewport = @viewport
			end
			# Window
			loop do
				update_ingame
				break if ret < 0 || Input.trigger?(Input::USE)
				update_main
				if ret < @apricorn.size
					set_visible_sprite("apricorn", true)
					file = GameData::Item.icon_filename(@apricorn[ret])
					@sprites["apricorn"].setBitmap(file)
				else
					set_visible_sprite("apricorn")
				end
				ret = Input.trigger?(Input::BACK) ? -1 : @sprites["cmdwindow"].index
			end
			# Animation
			file = GameData::Item.icon_filename(@apricorn[ret])
			set_bitmap("anim apricorn", file, @viewport) if !@sprites["anim apricorn"]
			@sprites["anim apricorn"].bitmap = Bitmap.new(file)
			ox = @sprites["anim apricorn"].src_rect.width / 2
			oy = @sprites["anim apricorn"].src_rect.height / 2
			set_oxoy_sprite("anim apricorn", ox, oy)
			set_zoom_sprite("anim apricorn", 0.5, 0.5)
			set_visible_sprite("anim apricorn", true)
			x = 266
			y = 10
			set_xy_sprite("anim apricorn", x, y)
			# Visible
			dispose("cmdwindow")
			set_visible_sprite("apricorn")
			dispose("left apricorn")

			# Result
			case ret
			# Exit
			when @apricorn.size, -1

				$PokemonGlobal.apricorn_juice_chose_first = true if $PokemonGlobal.apricorn_juice_first.size > 0

				set_visible_sprite("anim apricorn")
				@changeBottle = false
				update_bottle
				@choose = 0

			# Put apricorn
			else
				# Animation
				x = @sprites["lid"].src_rect.width
				set_src_xy_sprite("lid", x, 0)

				t  = 0
				x0 = @sprites["anim apricorn"].x
				y0 = @sprites["anim apricorn"].y
				loop do
					update_ingame

					if @sprites["anim apricorn"].x < 380
						r  = 60
						t += 0.1
						x  = r*(1-Math.cos(t))
						y  = r*(t-Math.sin(t))
						x += x0
						y += y0
						set_xy_sprite("anim apricorn", x, y)
					else
						set_visible_sprite("anim apricorn")
						break
					end

				end
				set_src_xy_sprite("lid", 0, 0)

				# Put to calculate
				# First times / Not first
				if $PokemonGlobal.apricorn_juice_chose_first
					# It counts to stop this action
					$PokemonGlobal.apricorn_juice_put += 1
					$PokemonGlobal.apricorn_juice_put  = MAX_LIMIT_MIXED if $PokemonGlobal.apricorn_juice_put > MAX_LIMIT_MIXED
				else
					$PokemonGlobal.apricorn_juice_first << @apricorn[ret] # Store first time to calculate
				end
				# All
				$PokemonGlobal.apricorn_juice_chose << @apricorn[ret]

				# Calculate (put number to calc)
				apricorn_to_number

				# Delete apricorn
				$PokemonBag.pbDeleteItem(@apricorn[ret], 1)
				@apricorn.delete_at(ret) if $PokemonBag.pbQuantity(@apricorn[ret]) == 0

				out = false
				# Not enough
				out = @apricorn.size == 0
				# Full
				if out
					update_message("You don't have any apricorns.")
				else

					# First times
					if !$PokemonGlobal.apricorn_juice_chose_first && $PokemonGlobal.apricorn_juice_first.size == 5
						update_message("You can't put it anymore!")
						out = true
					# Not first
					elsif $PokemonGlobal.apricorn_juice_put == MAX_LIMIT_MIXED
						update_message("You can't put it anymore! Take your aprijuice or walk / cycle and take it later.")
						out = true
					end

				end

				# Break
				if out
					$PokemonGlobal.apricorn_juice_chose_first = true if !$PokemonGlobal.apricorn_juice_chose_first
					@changeBottle = false
					update_bottle
					@choose = 0
				end

			end
		end

		#-----------------------------#
		# Change apricorn into number #
		#-----------------------------#
		def apricorn_to_number
			apri = $PokemonGlobal.apricorn_juice_chose # Apricorn
			arr  = [0, 0, 0, 0, 0]
			old  = $PokemonGlobal.apricorn_juice_flavor # Flavor
			apri.each_with_index { |a, i| arr = Pokeathlon.plus_minus_flavor(a, arr) }
			arr.map! { |a| a < 0 ? 0 : a > 63 ? 63 : a }
			# Check to decrease mildness
			same = false
			max1 = old.max
			maxindex1 = old.index(max1)
			old.each_with_index { |fla, i| same = true if fla == max1 && i != maxindex1 }
			if !same
				max2 = 0
				old.each { |fla| max2 = fla if fla > max2 && fla != max1 }
				maxindex2 = old.index(max2)
				old.each_with_index { |fla, i| same = true if fla == max2 && i != maxindex2 }
			end
			# Decrease (not same)
			if !same
				diff = old.map.with_index { |o, i| o - arr[i] }
				diff.map! { |d| d < 0 }
				arr2 = []
				diff.each_with_index { |d, i| arr2 << i if d }
				# Check if true is same position with old array
				notindex = false
				arr2.each { |po| notindex = true if po != maxindex1 && po != maxindex2 }
				if diff.include?(true) && notindex
					$PokemonGlobal.apricorn_juice_mildness -= 10
					$PokemonGlobal.apricorn_juice_mildness  = 0 if $PokemonGlobal.apricorn_juice_mildness < 0
				end
			end

			# Equal (set again) - Set flavor
			$PokemonGlobal.apricorn_juice_flavor = arr

			# Calculation (flavor) - strongest, lowest
			sum = arr.inject(:+)

			# First (strongest)
			if sum > 100
				if apri.include?(:BLACKAPRICORN)
					# Check if it doesn't check
					return if $PokemonGlobal.apricorn_juice_strongest_100
					$PokemonGlobal.apricorn_juice_strongest_first = rand(5) # 5 performances: power, stamina, skill, jump and speed
					$PokemonGlobal.apricorn_juice_strongest_100 = true
				elsif apri.include?(:WHITEAPRICORN)
					$PokemonGlobal.apricorn_juice_strongest_first = nil
				elsif arr.uniq.size == 1
					# Spicy / Power
					$PokemonGlobal.apricorn_juice_strongest_first = 0
				else

					# Check (in case it's first time.)
					return unless $PokemonGlobal.apricorn_juice_chose_first
					# Compare first time and addition
					# Old
					old = $PokemonGlobal.apricorn_juice_first
					points = [0, 0, 0, 0, 0]
					old.each_with_index { |a, i| points = Pokeathlon.plus_minus_flavor(a, points) }
					# New -> Check
					nowpoints = [0, 0, 0, 0, 0]
					incre     = [false, false, false, false, false]
					apri.each_with_index { |a, i|
						nowpoints = Pokeathlon.plus_minus_flavor(a, nowpoints)
						# Check
						nowpoints.each_with_index { |pt, j|
							next if pt - points[j] == 0
							incre[j] = true
						}
					}
					$PokemonGlobal.apricorn_juice_strongest_first = incre.include?(false) ? incre.index(false) : nil

				end
			else
				$PokemonGlobal.apricorn_juice_strongest_first = arr.index(arr.max)
			end
	
			# Second / Third / Lowest
			# Sort
			arrhash1 = [:spicy, :sour, :dry, :bitter, :sweet]
			arrhash2 = arr
			hash = {}
			arr.size.times { |i| hash[arrhash1[i]] = arrhash2[i] }
			hash = hash.sort_by(&:last)

			if !$PokemonGlobal.apricorn_juice_strongest_first.nil?
				index = arrhash1[$PokemonGlobal.apricorn_juice_strongest_first]
				hash = hash.to_h
				hash.delete(index)
				hash = hash.to_a
			end

			# Second
			$PokemonGlobal.apricorn_juice_strongest_second = arrhash1.index(hash[0][0])
			# Third
			$PokemonGlobal.apricorn_juice_strongest_third  = arrhash1.index(hash[1][0])
			# Lowest
			$PokemonGlobal.apricorn_juice_strongest_lowest = arrhash1.index(hash.last[0])

			# Update graphics
			update_graphics_bottle

		end

	end
end