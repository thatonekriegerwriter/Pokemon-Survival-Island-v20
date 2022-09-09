module BerryBlender
	class Show

		def update_main
			update_circle
			update_features
			update_effect
			update_speedTxt
			update_time_bar_auto
			if @result
				set_visible_sprite("result scene", true)
				# Draw result
				draw_result
				return if @countFade == 2
				# Increase count
				@countFade += 1
			end
		end

		#-------------#
		# Turn circle #
		#-------------#
		def update_circle
			# Increase speed
			if @result
				if @frames_rate > 0
					@frames_rate -= 3
					@frames_rate  = 0 if @frames_rate < 0
					# Update angle
					update_angle_circle
				else
					Graphics.frame_rate = @old_frames_rate
				end
				return
			end
			# Update angle
			update_angle_circle
		end

		def update_angle_circle
			return if @frames % @speed != 0
			Graphics.frame_rate = @old_frames_rate + @frames_rate
			# Update circle sprite
			@sprites["circle"].angle += 10
			@sprites["circle"].angle %= 360
		end

		# Use when player press perfect, good or miss
		def update_speed_increse(num)
			@speed -= num
			@speed  = 1 if @speed < 1
			@frames_rate = update_speed(true, @frames_rate, num) if @speed == 1
			@frames_rate = 120 - @old_frames_rate if @old_frames_rate + @frames_rate > 120
			# Update @speedTxt
			update_speedTxt_press(true, num)
			@notPress = @player == 0 ? 400 : 100 * @player
		end

		def update_speed_decrease(num)
			if @frames_rate == 0
				@speed += num
				@speed  = MAX_SPEED if @speed >= MAX_SPEED
			else
				@frames_rate = update_speed(false, @frames_rate, num)
				@frames_rate = 0 if @frames_rate < 0
			end
			# Update @speedTxt
			update_speedTxt_press(false, num)
			@notPress = @player == 0 ? 400 : 100 * @player
		end

		def update_speed(plus, realnum, num)
			return 0 if @speed != 1
			sum = @old_frames_rate + @frames_rate
			if sum >= 100 && sum <= 120
				plus ? (realnum += num) : (realnum -= num * 1.5)
			elsif sum >= 80 && sum < 100
				plus ? (realnum += (num * 2.0)) : (realnum -= num * 1.7)
			elsif sum >= 40 && sum < 80
				plus ? (realnum += (num * 2.5)) : (realnum -= num * 1.5)
			else
				plus ? (realnum += (num * 3)) : (realnum -= num * 2)
			end
			return realnum.round(2)
		end

		#-----------------------------------#
		# Speed text (speed to define item) #
		#-----------------------------------#
		def update_speedTxt_press(plus, num)
			if @speed.between?(2, MAX_SPEED-1)
				@speedTxt += 0.5
				@speedTxt  = 12 if @speedTxt > 12
			end
			@speedTxt = update_speed(plus, @speedTxt, num)
			@speedTxt = 7 if @speedTxt < 7
			@speedTxt = 110 if @speedTxt > 110
		end

		def update_speedTxt
			return if @result
			# Check if player doesn't play
			@notPress -= 1
			@notPress  = 0 if @notPress < 0
			# Save max speed
			@maxSpeed = [@maxSpeed, @speedTxt].max
			return if @notPress > 0
			@speedTxt -= 1
			@speedTxt  = 7 if @speedTxt < 7
			@frames_rate -= 1
			@frames_rate  = 0 if @frames_rate < 0
			@speed += 1 if @frames_rate == 0
			@speed  = MAX_SPEED if @speed >= MAX_SPEED
		end

		#--------#
		# Effect #
		#--------#
		def update_effect
			if @result
				2.times { |j|
					10.times { |i| set_visible_sprite("effect #{j} #{i}") }
				}
			else
				@trigger_effect.each { |k, v|
					next unless @trigger_effect[k][0]
					@trigger_effect[k][1] += 1
					one = @old_frames_rate
					two = @old_frames_rate + @frames_rate
					next if @trigger_effect[k][1] <= two * 5 / two
					2.times { |i| set_visible_sprite("effect #{i} #{k}") }
					@trigger_effect[k] = [false, 0]
				}
				return unless @showEffect
				random1 = rand(10)
				@showEffect = false
				return if @trigger_effect[random1][0]
				2.times { |i|
					x = rand(Graphics.width)
					y = rand(Graphics.height)
					set_xy_sprite("effect #{i} #{random1}", x, y)
					set_visible_sprite("effect #{i} #{random1}", true)
				}
				@trigger_effect[random1][0] = true
			end
		end

		#-------------------------------#
		# Features: perfect, good, miss #
		#-------------------------------#
		def update_features
			return if @checkall
			@showFeature.each { |k, v|
				arr = [:perfect, :good, :miss]
				arr.each_with_index { |name, i| v[name] = @result ? update_dispose_all_features(v[name], i, k) : update_small_features(v[name], i, k) }
			}
			@checkall = true if @result
		end

		def update_small_features(arr, feature, nameplayer)
			return [] if arr.size == 0
			arr2 = ["Perfect", "Good", "Miss"]
			name = feature == 0 ? :perfect : feature == 1 ? :good : :miss
			arr.each_with_index { |a, i|
				spritename = "#{arr2[feature]} #{@count[nameplayer][name]}"
				arr[i] -= 1
				arr[i]  = 0 if a < 0
				dispose(spritename) if a == 1
			}
			return arr
		end

		def update_dispose_all_features(arr, feature, nameplayer)
			return [] if arr.size == 0
			arr2 = ["Perfect", "Good", "Miss"]
			name = feature == 0 ? :perfect : feature == 1 ? :good : :miss
			arr.each_with_index { |a, i|
				spritename = "#{arr2[feature]} #{@count[nameplayer][name]}"
				dispose(spritename) if !@sprites[spritename].nil?
			}
		end

		#-------------#
		# Update time #
		#-------------#
		def update_time_bar(num)
			return if @result
			if @sprites["time bar"].x + num > 188
				@sprites["time bar"].x = 188
				# Store result
				set_order_result
				# Fade
				fade_in
				@result = true
				return
			end
			@sprites["time bar"].x += num
		end

		def update_time_bar_auto = update_time_bar(0.5)

	end
end