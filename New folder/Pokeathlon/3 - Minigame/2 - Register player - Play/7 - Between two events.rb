module Pokeathlon
	class Play_Athlon

		def show_create_between_2_events
			# Set background
			@sprites["bg each event"].y -= 46
			set_visible_sprite("animated result event", true)
			set_visible_sprite("bg result left event", true)
			set_visible_sprite("bg result right event", true)
			set_visible_sprite("bg each event", true)

			# Set podium
			x = Settings::SCREEN_WIDTH - @sprites["podium result"].bitmap.width
			y = @sprites["bg each event"].y
			set_xy_sprite("podium result", x, y)
			x += @sprites["podium result"].bitmap.width / 2
			y += 5
			set_xy_sprite("examiner podium result", x, y)

			set_visible_sprite("examiner podium result", true)
			set_visible_sprite("podium result", true)
			# Name
			draw_name_right_screen_text
			# Draw number (000)
			update_number_on_table
		end

		# Use when moving result bar
		# first: string - example: "Total times: "
		# last: string - example: " seconds"
		def move_result_bar(first="", last="", tof=false, notreverse=false)
			hash = {}
			4.times { |i| hash[i] = @store[:score_special][i] }
			hash = notreverse ? hash.sort_by(&:last).to_h : hash.sort_by(&:last).reverse.to_h
			name = hash.keys
			points = hash.values

			# Store champion of this course (small event)
			@store[:champ_fake] = @store[:team][name[0]*3]

			4.times { |ii|
				i = 4 - ii - 1
				@sprites["order bar #{i}"].src_rect.y = name[i] * @sprites["order bar #{i}"].src_rect.height

				# Move
				limitx = Settings::SCREEN_WIDTH
				minus  = 32

				# Name of players
				str1 = []
				4.times { |j| str1 << @store[:team][name[j]*3] }

				# Result
				str2 = []
				4.times { |j|
					str  = ""
					str += first
					str += (tof ? sprintf("%0.1f", points[j]) : "#{points[j]}")
					str += last
					str2 << str
				}

				# Character
				file = "Graphics/Characters/#{@store[:character_file][name[i]]}"
				@sprites["character result #{i}"].bitmap = Bitmap.new(file)
				w = @sprites["character result #{i}"].bitmap.width / 4
				h = @sprites["character result #{i}"].bitmap.height / 4
				set_src_wh_sprite("character result #{i}", w, h)

				loop do
					update_ingame

					# Update bg behind
					update_animated_result_mess(false, true)

					# Animation
					x  = @sprites["order bar #{i}"].x
					x -= minus
					x  = limitx if x < limitx
					@sprites["order bar #{i}"].x = x
					@sprites["order numbers #{i}"].x = x
					@sprites["character result #{i}"].x = x + 62 + 5
					if i == 0
						set_visible_sprite("crown first place", true) unless @sprites["crown first place"].visible
						@sprites["crown first place"].x = @sprites["character result #{i}"].x + @sprites["character result #{i}"].src_rect.width / 2
					end

					# Draw text
					text = []
					# Name
					xx = x + 130
					y  = @sprites["order bar #{i}"].y + 2
					text << [str1[i], xx, y, 0, Color.new(0, 0, 0)]
					y += 32
					text << [str2[i], xx, y, 0, Color.new(0, 0, 0)]
					drawTxt("result event text #{i}", text)

					break if @sprites["order bar #{i}"].x <= limitx
				end
			}
		end

		# Use when starting new event or finish the latest event
		def reset_position_result
			# Result (event)
			clearTxt("result left text")

			set_visible_sprite("animated result event")
			set_visible_sprite("bg result left event")
			set_visible_sprite("bg result right event")

			# Crown
			set_visible_sprite("crown first place")
			@sprites["crown first place"].src_rect.x = 0
			# Podium
			set_visible_sprite("examiner podium result")
			set_visible_sprite("podium result")

			# Order bar
			xx = Settings::SCREEN_WIDTH
			4.times { |i|
				h = @sprites["order bar #{i}"].src_rect.height
				# Bar
				y = 50 + 2 + h * i
				set_xy_sprite("order bar #{i}", xx * 2, y)
				# Numbers
				yy = y + 10
				set_xy_sprite("order numbers #{i}", xx * 2, yy)
				x  = @sprites["order bar #{i}"].x + 62
				yy = y + 8
				set_xy_sprite("character result #{i}", x, yy)
				clearTxt("result event text #{i}")
			}
			# Small background
			@sprites["bg each event"].y += 46
		end

		#------#
		# Text #
		#------#
		def draw_name_right_screen_text
			clearTxt("result left text")
			text = []
			4.times { |i|
				x = 2 + 130 * i
				y = -8
				text << [@store[:team][3*i], x, y, 0, Color.new(0, 0, 0)]
			}
			drawTxt("result left text", text)
		end

		#-----------------#
		# Animated result #
		#-----------------#
		def animated_bg_result
			@sprites["animated result event"].ox -= 0.5
			@sprites["animated result event"].oy -= 0.5
		end

		def animated_crown
			@frames += 1
			return if @frames % 4 != 0
			w = @sprites["crown first place"].src_rect.width
			wmax = @sprites["crown first place"].bitmap.width
			if w + @sprites["crown first place"].src_rect.x >= wmax
				@sprites["crown first place"].src_rect.x = 0
			else
				@sprites["crown first place"].src_rect.x += w
			end
		end

		def update_animated_result_mess(crown=true, notupdate=false)
			update unless notupdate
			# Animated
			animated_bg_result
			animated_crown if crown
		end

	end
end