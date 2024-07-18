module Pokeathlon
	class Play_Athlon

		def create_scene(pkmn)

			# Create bg (left)
			create_sprite("bg left", "bg_main", @Viewport)
			
			# Random graphics
			inter = pbMapInterpreter
			event = []
			3.times { |i| event << inter.get_character(CANDIDATS[i]) }
			if RANDOM_GRAPHIC_CANDIDAT
				3.times { |i| event[i].character_name = SAME_RANDOM_CANDIDAT ? ARRAY_SAME_RANDOM_CANDIDAT.sample : ARRAY_SEPARATE_RANDOM_CANDIDAT[i].sample }
			end
			# Store file name of character
			@store[:character_file] = []
			@store[:character_file] << $game_player.character_name.clone
			3.times { |i| @store[:character_file] << event[i].character_name.clone }
			# Create character
			characterfolder = "Graphics/Characters/"
			# Examiner
			file = GRAPHIC_EXAMINER.size == 0 ? inter.get_character(EXAMINER).character_name : GRAPHIC_EXAMINER.sample
			set_bitmap("examiner", characterfolder + file, @viewport)
			w = @sprites["examiner"].bitmap.width / 4
			h = @sprites["examiner"].bitmap.height / 4
			set_src_wh_sprite("examiner", w, h)
			set_oxoy_sprite("examiner", w / 2, h / 2)
			x = 240 + 15
			y = 246 + 4 - h / 2
			set_xy_sprite("examiner", x, y)
			# Candidats
			4.times { |i|
				file = characterfolder + @store[:character_file][i]
				set_bitmap("candidat #{i}", file, @viewport)
				w = @sprites["candidat #{i}"].bitmap.width / 4
				h = @sprites["candidat #{i}"].bitmap.height / 4
				set_src_wh_sprite("candidat #{i}", w, h)
				set_src_xy_sprite("candidat #{i}", 0, 3 * h)
				set_oxoy_sprite("candidat #{i}", w / 2, h / 2)
				x = 48 + 15 + 128 * i
				y = 292 + 8 - h / 2
				set_xy_sprite("candidat #{i}", x, y)
			}

			# Create bg
			create_sprite("bg", "Wait Scene", @viewport)
			xx = Settings::SCREEN_WIDTH
			set_xy_sprite("bg", xx, 0)
			# Create pokemon
			pkmn_shadow_bitmap(pkmn)
			pkmn_shadow_xy_condition(pkmn, 60 + 512, 65, 3, 132, 99)
			pkmn_shadow_src_xy([0, pkmn.size-1], 0, 3)

			# Get medal (scene)
			# Background
			create_sprite("white", "White", @viewport)
			yy = (Graphics.height - @sprites["white"].bitmap.height) / 2
			set_xy_sprite("white", xx, yy)
			set_visible_sprite("white")
			# Medal
			file = "Graphics/Pokeathlon/Stats/Medal"
			set_bitmap("medal", file, @viewport)
			w = @sprites["medal"].bitmap.width / 5
			h = @sprites["medal"].bitmap.height
			set_src_wh_sprite("medal", w, h)
			set_oxoy_sprite("medal", w / 2, h / 2)
			zoom = 2
			set_zoom_sprite("medal", zoom, zoom)
			x = Settings::SCREEN_WIDTH * 3 / 2
			y = yy + h / 2
			set_xy_sprite("medal", x, y)
			set_visible_sprite("medal")
			# Pokemon
			3.times { |i| @sprites["pkmn get medal #{i}"] = Sprite.new(@viewport) }

			# Result each event
			# Animated
			@sprites["animated result event"] = AnimatedPlane.new(@viewport)
			@sprites["animated result event"].setBitmap("Graphics/Pokeathlon/Minigame/00 - Main/bg_results")
			set_visible_sprite("animated result event")
			# Scene
			create_sprite("bg result left event", "Result event - left", @viewport)
			set_visible_sprite("bg result left event")
			create_sprite("bg result right event", "Result event - right", @viewport)
			set_xy_sprite("bg result right event", xx, 0)
			set_visible_sprite("bg result right event")
			# Text (name of player - result)
			create_sprite_2("result left text", @viewport)
			# Create result bar
			4.times { |i|
				# Set again src rect when event shows order
				create_sprite("order bar #{i}", "Order bar", @viewport)
				w = @sprites["order bar #{i}"].bitmap.width
				h = @sprites["order bar #{i}"].bitmap.height / 4
				set_src_wh_sprite("order bar #{i}", w, h)
				y = 50 + 2 + h * i
				set_xy_sprite("order bar #{i}", xx * 2, y)

				# Set order (not need to rearrange)
				create_sprite("order numbers #{i}", "Order", @viewport)
				w = @sprites["order numbers #{i}"].bitmap.width / 4
				h = @sprites["order numbers #{i}"].bitmap.height
				set_src_wh_sprite("order numbers #{i}", w, h)
				set_src_xy_sprite("order numbers #{i}", i * w, 0)
				yy = y + 10
				set_xy_sprite("order numbers #{i}", xx * 2, yy)

				# Character
				file = "Graphics/Characters/#{@store[:character_file][i]}"
				set_bitmap("character result #{i}", file, @viewport)
				w = @sprites["character result #{i}"].bitmap.width / 4
				h = @sprites["character result #{i}"].bitmap.height / 4
				set_src_wh_sprite("character result #{i}", w, h)
				x  = @sprites["order bar #{i}"].x + 62
				yy = y + 8
				set_xy_sprite("character result #{i}", x, yy)
				# Text
				create_sprite_2("result event text #{i}", @viewport)
			}
			# Crown of first place
			create_sprite("crown first place", "Crown", @viewport)
			w = @sprites["crown first place"].bitmap.width / 3
			h = @sprites["crown first place"].bitmap.height
			set_src_wh_sprite("crown first place", w, h)
			set_oxoy_sprite("crown first place", w / 2, h / 2)
			@sprites["crown first place"].y = @sprites["character result 0"].y
			set_visible_sprite("crown first place")

			# Store position uses
			# 	in case, show table between two events
			@store[:table_score] = []
			# 	in case, show table in result scene
			@store[:table_score_result] = []

			# Number (number of player)
			4.times { |i|
				create_sprite("table score #{i}", "Table", @viewport)
				w = @sprites["table score #{i}"].bitmap.width / 4
				h = @sprites["table score #{i}"].bitmap.height
				set_src_wh_sprite("table score #{i}", w, h)
				set_src_xy_sprite("table score #{i}", i * w, 0)
				set_oxoy_sprite("table score #{i}", w / 2, h / 2)

				x = 64 + 128 * i
				y = 28 + h / 2

				# Store
				@store[:table_score] << [x, y]

				y = 190 - h / 2

				# Store
				@store[:table_score_result] << [x, y]

				set_xy_sprite("table score #{i}", x, y)

				# Number
				3.times { |j|
					create_sprite("number table #{i} #{j}", "ScoreNumbers", @viewport)
					ww = @sprites["number table #{i} #{j}"].bitmap.width / 10
					hh = @sprites["number table #{i} #{j}"].bitmap.height
					set_src_wh_sprite("number table #{i} #{j}", ww, hh)
					set_oxoy_sprite("number table #{i} #{j}", ww / 2, hh / 2)
					xxx = x - w / 2 + 16 + ww / 2 + (1 + ww) * j
					set_xy_sprite("number table #{i} #{j}", xxx, y)
				}
			}

			# Begin each event / between 2 events
			@sprites["bg start event"] = Sprite.new(@viewport) # Start
			@sprites["bg each event"]  = Sprite.new(@vp2)      # Mini bg to show event (Hurdle Dash, etc)
			@sprites["descrip event"]  = Sprite.new(@viewport) # Rules of events, bitmap / graphics
			set_xy_sprite("descrip event", xx, 0)
			# Event name
			create_sprite_2("event text", @viewport)

			# Result scene (Examiner)
			file = GRAPHIC_EXAMINER.size == 0 ? inter.get_character(EXAMINER).character_name : GRAPHIC_EXAMINER.sample
			set_bitmap("examiner podium result", characterfolder + file, @vp2)
			w = @sprites["examiner podium result"].bitmap.width / 4
			h = @sprites["examiner podium result"].bitmap.height / 4
			set_src_wh_sprite("examiner podium result", w, h)
			set_oxoy_sprite("examiner podium result", w / 2, h / 2)
			zoom = 1.5
			set_zoom_sprite("examiner podium result", zoom, zoom)
			set_visible_sprite("examiner podium result")
			# Podium
			create_sprite("podium result", "Podium", @vp2)
			set_visible_sprite("podium result")

			# Black
			create_sprite("black", "Black", @viewport)
			set_xy_sprite("black", xx, 0)
		end

		#-----------#
		# Draw text #
		#-----------#
		# str: string -> "Event 1", etc
		def draw_start_finish_event(finish=false, str="")
			clearTxt("event text")
			text = []
			if finish
				4.times { |i|
					string = @store[:team][3*i]
					x = 512 / 4 * i
					y = 0
					text << [string, x, y, 0, Color.new(0, 0, 0), Color.new(255, 255, 255)]
				}
			else
				bitmap = @sprites["event text"].bitmap
				x = 140 + (232 - bitmap.text_size(str).width) / 2
				y = 73 + 3
				text << [str, x, y, 0, Color.new(0, 0, 0), Color.new(255, 255, 255)]
			end
			drawTxt("event text", text)
		end

		#--------#
		# Update #
		#--------#
		def update_animated_pokemon(pkmn, notup=false)
			# Update (use in message)
			update if !notup
			# Animated
			@frames += 1
			return if @frames % 4 != 0
			pkmn.size.times { |i|
				if @sprites["pkmn #{i}"].src_rect.x + @sprites["pkmn #{i}"].src_rect.width == @sprites["pkmn #{i}"].bitmap.width
					@sprites["pkmn #{i}"].src_rect.x = 0
				else
					@sprites["pkmn #{i}"].src_rect.x += @sprites["pkmn #{i}"].src_rect.width
				end
			}
		end

		# Update score
		def update_number_on_table(number=nil, move=false)
			score = []
			if number.nil?
				number = []
				4.times {
					number << "000"
					score << 0
				}
			else
				number = number.clone
				4.times { |i| score << number[i] }
				number.map! { |num| num > 999 ? "999" : sprintf("%03d", num) }
			end
			4.times { |i|
				# Between 2 events
				@sprites["table score #{i}"].y = @store[:table_score][i][1]
				# Move table (result scene)
				if move
					h = @sprites["table score #{i}"].src_rect.height
					distance = 190 - h
					@sprites["table score #{i}"].y = @store[:table_score_result][i][1] - score[i] / 999.0 * distance
				end

				# Update score
				y = @sprites["table score #{i}"].y
				arr = number[i].split(//)
				arr.map!(&:to_i)
				3.times { |j|
					w = @sprites["number table #{i} #{j}"].src_rect.width
					@sprites["number table #{i} #{j}"].src_rect.x = arr[j] * w
					@sprites["number table #{i} #{j}"].y = y
				}
			}
		end

	end
end