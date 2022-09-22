module Pokeathlon
	class Play_Athlon

		# Message: pbMessage
		def mess(str="", line=false, &block) = Pokeathlon.custom_message(_INTL(str), Settings::SCREEN_WIDTH, line, nil, 0, nil, 0, &block)

		# Reset (default):
		# width: Screen width * 2
		# height: Screen height
		def reset_screen
			cs = Pokeathlon::Change_Screen_Choose_pkmn
			cs.resize_exact(@store[:screen][0], @store[:screen][1])
		end

		# Play
		def play
			# Set value
			namecourse = Pokeathlon.course_name
			pkmn = Pokeathlon.infor_course.clone
			@store[:species] = pkmn.keys # Pokemon.new
			@store[:id]   = []
			@store[:team] = []
			@store[:miss] = []
			@store[:pos]  = []
			pkmn.each { |k, v|
				@store[:id] << v[:id]
				@store[:team] << v[:team]
				@store[:miss] << 0
				@store[:pos] << v[:position] # Use [0..2] -> Call position of player's pokemon
			}
			# Score, use after match
			@store[:score]  = [0, 0, 0, 0]
			# Each event, 3.times -> max is 3 events
			@store[:scoref] = []
			3.times { |i| @store[:scoref] << @store[:score].clone }
			# It stores points (not yet converted points)
			# It will rearrange after event finish
			@store[:score_special] = []
			# Store champion of each event
			@store[:champ_fake] = ""
			# It stores points of each pokemon (sum)
			@store[:score_individual] = []
			12.times { @store[:score_individual] << 0 }

			# Screen (after event starts, reset screen)
			@store[:screen] = [Graphics.width, Graphics.height]

			# Store stats of pokemon: speed, power, skill, stamina and jump
			oristat = []
			12.times { |i| oristat << @store[:species][i].athlon_normal.clone }

			# Scene
			create_scene(@store[:species])
			# Presentation
			mess("Welcome to the Pokeathlon!")
			mess("Today's event --\nthe #{namecourse} Course!")
			mess("Who will shine brightest today?\nLet's meet the competitors!")
			# Show pokemon
			fade_in
			15.times { @sprites["black"].opacity -= 17 }
			fade_out
			# Presentation (next)

			# Player
			mess("First") { update_animated_pokemon(@store[:species]) }

			# Animation - Down
			player_turn_up_down(0, true)
			pkmn_shadow_src_xy([0, 2], nil, 0)

			# Team
			teampkmn = ""
			3.times { |j|
				teampkmn += "#{@store[:id][j].to_s.capitalize}"
				teampkmn += ", " if j < 2
			}
			mess("Team #{@store[:team][0]}: #{teampkmn}") { update_animated_pokemon(@store[:species]) }

			# Animation - Up
			player_turn_up_down(0)
			pkmn_shadow_src_xy([0, 2], nil, 3)

			# AI
			arrmess = ["Second", "Third", "And..."]
			3.times { |i|
				mess(arrmess[i]) { update_animated_pokemon(@store[:species]) }

				# Animation - Down
				player_turn_up_down(i + 1, true)
				pkmn_shadow_src_xy([(3 + i * 3), (5 + i * 3)], nil, 0)

				# Team
				teampkmn = ""
				3.times { |j|
					teampkmn += "#{@store[:id][j+3+3*i].to_s.capitalize}"
					teampkmn += ", " if j+3+3*i < 2+3+3*i
				}
				mess("Team #{@store[:team][3+3*i]}: #{teampkmn}") { update_animated_pokemon(@store[:species]) }

				# Animation - Up
				player_turn_up_down(i + 1)
				pkmn_shadow_src_xy([(3 + i * 3), (5 + i * 3)], nil, 3)
			}

			mess("All right, we're ready!\nAim for the top! Let's") { update_animated_pokemon(@store[:species]) }
			mess("<fs=80><ac>POKEATHLON</ac></fs>", true) { update_animated_pokemon(@store[:species]) }

			# Play event #
			event_start(namecourse)

			# Fade
			fade_in

			# Finish #
			# Reset
			reset_position_result
			update_number_on_table(nil, true)

			set_visible_sprite("bg each event")
			@sprites["black"].opacity = 0
			fade_out

			mess("Great job, athletes!") { update_animated_pokemon(@store[:species]) }
			mess("Which team fought the hardest?\nWe've got the results!") { update_animated_pokemon(@store[:species]) }
			mess("But first...\nwho's overflowing with fighting spirit?") { update_animated_pokemon(@store[:species]) }

			# Challenge Bonus
			mess("A Challenge Bonus for\nPokemon and Team!") { update_animated_pokemon(@store[:species]) }
			# Increase points
			sum = []
			num = 0
			12.times { |i|
				num += oristat[i].inject(:+)
				if i % 3 == 2
					sum << num
					num = 0
				end
			}
			scorefake = @store[:score].clone
			@store[:score].map!.with_index { |sc, i| sc += (75 - sum[i]) }
			# Animated
			4.times { |i|

				mess("#{@store[:score][i]} points for Team #{@store[:team][3*i]}") { update_animated_pokemon(@store[:species]) }

				@store[:score][i].times {
					# Update
					update_ingame
					update_animated_pokemon(@store[:species], true)
					# Add
					scorefake[i] += 1
					update_number_on_table(scorefake, true)
				}
			}

			# No-Miss Bonus
			mess("Continuing on, the individual prizes...") { update_animated_pokemon(@store[:species]) }
			count = @store[:miss].count { |mi| mi == 0 } > 0
			if count
				mess("The No-Miss Bonus!") { update_animated_pokemon(@store[:species]) }
				# Increase points
				scorefake = @store[:score].clone
				pos = []

				12.times { |i|
					next if @store[:miss][i] > 0
					@store[:score][i/3] += 10
					pos << i
				}
				# Animated
				pos.each { |po|

					mess("Team #{@store[:team][po]}'s #{@store[:id][po]}") {
						update_animated_pokemon(@store[:species])
						pkmn_shadow_src_xy([po, po], nil, 0)
					}
	
					10.times {
						# Update
						update_ingame
						update_animated_pokemon(@store[:species], true)
						# Add
						scorefake[po/3] += 1
						update_number_on_table(scorefake, true)
					}

					pkmn_shadow_src_xy([po, po], nil, 3)
				}
				mess("That's all!") { update_animated_pokemon(@store[:species]) }
			else
				mess("There wasn't one this time.") { update_animated_pokemon(@store[:species]) }
			end

			# Leading Score Bonus
			mess("Moving on...\nthe points leader!") { update_animated_pokemon(@store[:species]) }
			# Increase points
			max = @store[:score_individual].max
			scorefake = @store[:score].clone
			pos = []

			@store[:score_individual].each_with_index { |sc, i|
				next if sc != max
				@store[:score][i/3] += 10
				pos << i
			}
			# Animated
			pos.each { |po|

				mess("Team #{@store[:team][po]}'s #{@store[:id][po]}") {
					update_animated_pokemon(@store[:species])
					pkmn_shadow_src_xy([po, po], nil, 0)
				}

				10.times {
					# Update
					update_ingame
					update_animated_pokemon(@store[:species], true)
					# Add
					scorefake[po/3] += 1
					update_number_on_table(scorefake, true)
				}

				pkmn_shadow_src_xy([po, po], nil, 3)
			}

			# Name of pokemon + Team (message)
			mess("That's all!") { update_animated_pokemon(@store[:species]) }

			# Effort Bonus - just `missed collecting the most points` - only one
			mess("Next up...\nthe prize for effort!") { update_animated_pokemon(@store[:species]) }
			mess("The Pokemon that missed collecting the most points...") { update_animated_pokemon(@store[:species]) }
			# Increase points
			max = @store[:miss].max
			scorefake = @store[:score].clone
			pos = []

			@store[:miss].each_with_index { |sc, i|
				next if sc != max
				@store[:score][i/3] += 10
				pos << i
			}
			pos.each { |po|

				mess("Team #{@store[:team][po]}'s #{@store[:id][po]}") {
					update_animated_pokemon(@store[:species])
					pkmn_shadow_src_xy([po, po], nil, 0)
				}

				10.times {
					# Update
					update_ingame
					update_animated_pokemon(@store[:species], true)
					# Add
					scorefake[po/3] += 1
					update_number_on_table(scorefake, true)
				}

				pkmn_shadow_src_xy([po, po], nil, 3)
			}

			mess("That's all!") { update_animated_pokemon(@store[:species]) }

			# Points (3 events)
			mess("Finally...\nwe'll add up the event points!") { update_animated_pokemon(@store[:species]) }
			arr = ["Event 1", "Event 2", "Event 3"]
			3.times { |i|
				mess(arr[i]) { update_animated_pokemon(@store[:species]) }
				# Increase points
				scorefake = @store[:score].clone
				
				@store[:scoref][i].each_with_index { |sc, j| @store[:score][j] += sc.round }
				max = @store[:score].max
				index = @store[:score].index(max)
				minus = (max - scorefake[index])
				diff = []
				4.times { |j| diff << (@store[:score][j] - scorefake[j]) }

				minus.times {
					# Update
					update_ingame
					update_animated_pokemon(@store[:species], true)
					4.times { |j|
						next if diff[j] == 0
						# Add
						scorefake[j] += 1
						diff[j] -= 1
						update_number_on_table(scorefake, true)
					}
				}
			}
			max = @store[:score].max
			index = @store[:score].index(max)
			mess("The overall winner, with #{max} points...") { update_animated_pokemon(@store[:species]) }

			# Turn down (event) - Show 3 pokemons
			player_turn_up_down(index, true)

			set_visible_sprite("white", true)
			3.times { |i|
				pkmn = @store[:species][index*3+i]
				file = GameData::Species.front_sprite_filename(pkmn.species, pkmn.form, pkmn.gender, pkmn.shiny?, pkmn.shadowPokemon?)
				@sprites["pkmn get medal #{i}"].bitmap = Bitmap.new(file)
				h = @sprites["pkmn get medal #{i}"].bitmap.height
				set_src_wh_sprite("pkmn get medal #{i}", h, h)
				set_oxoy_sprite("pkmn get medal #{i}", h / 2, h / 2)
				x = Settings::SCREEN_WIDTH + 1 + 160 / 2 + 160 * i
				y = Graphics.height / 2
				set_xy_sprite("pkmn get medal #{i}", x, y)
			}

			mess("<fs=80><ac>Team #{@store[:team][3*index]}</ac></fs>", true) { update_animated_pokemon(@store[:species]) }

			# Show medal
			w = @sprites["medal"].src_rect.width
			course = ["Speed", "Power", "Skill", "Stamina", "Jump"]
			x = course.index(namecourse)
			set_src_xy_sprite("medal", x * w, 0)
			set_visible_sprite("medal", true)

			mess("Team #{@store[:team][3*index]} was awarded\nthe #{namecourse} Medal") { update_animated_pokemon(@store[:species]) }
			mess("You did well on the\n#{namecourse} Course!") { update_animated_pokemon(@store[:species]) }

			# Show message
			mess("Congratulations!\nThat was a wonderful Performance!") { update_animated_pokemon(@store[:species]) }
			mess("Keep aiming to be the top Pokeathlete!") { update_animated_pokemon(@store[:species]) }
			mess("That is...\nPokeathlon") { update_animated_pokemon(@store[:species]) }
			mess("<fs=80><ac>FOREVER</ac></fs>", true) { update_animated_pokemon(@store[:species]) }

			# Get medal if player won (pokemon get)
			3.times { |i| $player.party[@store[:pos][i]].athlon_medal[x] = true } if index == 0
			$PokemonGlobal.athlon_points_play = @store[:score][0]
			$PokemonGlobal.athlon_points_play += 100 if index == 0

			# Reset
			Pokeathlon.reset_infor_course
			Pokeathlon.set_course_name("")
			# Delete all
			fade_in
			endScene
		end

		# Events
		# Store value in each event: score and miss points to calculate
		def event_start(name)

			# Black again
			fade_in # Fade
			@sprites["black"].opacity = 255

			# Set event (background)
			show_start_event("Event 1", true)

			# Array
			arrpr = [] # Store proc, call script (minigame) to play
			arrre = [] # Store string, show text after playing

			case name
			# Speed course
			when "Speed"

				eventname = ["Hurdle Dash", "Pennant Capture", "Relay Run"]

				# Hurdle Dash
				arrpr << proc { Pokeathlon.minigame_hurdle_dash(@store[:species], @store[:id]) }

				# Random number - I don't have events. So, I use random
				# Pennant Capture
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << rand(35)
						score << (scorein[i] * 3)
					}
					[score, miss, scorein, individual]
				}

				# Relay Run
				# `A player may not earn more than 200 Athlete Points even if their Pokémon ran more than 20 laps.`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << (rand(12) + (rand(2)==0 ? 0 : (0.1 * rand(10))))
						score << (scorein[i] * 10)
					}
					[score, miss, scorein, individual]
				}

				# Show string (unit, total) in result scene
				arrre << ["Total Time: ", " Seconds", true, true]
				arrre << ["Total: ", ""]
				arrre << ["Total Distance: ", " Laps", true]

			# Power course
			when "Power"

				eventname = ["Block Smash", "Circle Push", "Goal Roll"]

				# Random number - I don't have events. So, I use random
				# Block Smash
				# Maximum is 200
				arrpr << proc { Pokeathlon.minigame_block_smash(@store[:species], @store[:id]) }

				# Circle Push
				# 66: perfect score
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(2)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << rand(40)
						score << (scorein[i] * 3)
					}
					[score, miss, scorein, individual]
				}

				# Goal Roll
				# `A player may not earn more than 200 Athlete Points even if they scored more than 20 (assuming this is the highest of the four scores)`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					rank = [0, 1, 2, 3]
					rank = rank.shuffle
					12.times {
						miss << rand(4)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						pos = rank[i]
						scorein[pos] = (4 - i)
						num = 60 + scorein[pos] * 5 + [40, 20, 10, 0][i]
						score[pos] = num
					}
					[score, miss, scorein, individual]
				}

				# Show string (unit, total) in result scene
				arrre << ["Total Pieces: ", ""]
				arrre << ["Total: ", " Points"]
				arrre << ["Total: ", " Points"]

			# Skill course
			when "Skill"

				eventname = ["Snow Throw", "Goal Roll", "Pennant Capture"]

				# Random number - I don't have events. So, I use random
				# Snow Throw
				# `A player may not earn more than 200 Athlete Points even if they scored more than 66 hits.`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times {
						scorein << rand(30)
						score << (scorein[i] * 3)
					}
					[score, miss, scorein, individual]
				}

				# Goal Roll
				# `A player may not earn more than 200 Athlete Points even if they scored more than 20 (assuming this is the highest of the four scores)`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					rank = [0, 1, 2, 3]
					rank = rank.shuffle
					12.times {
						miss << rand(4)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						pos = rank[i]
						scorein[pos] = (4 - i)
						num = 60 + scorein[pos] * 5 + [40, 20, 10, 0][i]
						score[pos] = num
					}
					[score, miss, scorein, individual]
				}

				# Pennant Capture
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << rand(35)
						score << (scorein[i] * 3)
					}
					[score, miss, scorein, individual]
				}

				# Show string (unit, total) in result scene
				arrre << ["Total: ", ""]
				arrre << ["Total: ", " Points"]
				arrre << ["Total: ", ""]

			# Stamina course
			when "Stamina"

				eventname = ["Ring Drop", "Relay Run", "Block Smash"]

				# Random number - I don't have events. So, I use random
				# Ring Drop
				# `A player may not earn more than 200 Athlete Points even if they scored more than 134.`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times {
						scorein << rand(70)
						score << (scorein[i] * 1.5).to_i
					}
					[score, miss, scorein, individual]
				}

				# Relay Run
				# `A player may not earn more than 200 Athlete Points even if their Pokémon ran more than 20 laps.`
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << (rand(12) + (rand(2)==0 ? 0 : (0.1 * rand(10))))
						score << (scorein[i] * 10)
					}
					[score, miss, scorein, individual]
				}

				# Block Smash
				# Maximum is 200
				arrpr << proc { Pokeathlon.minigame_block_smash(@store[:species], @store[:id]) }

				# Show string (unit, total) in result scene
				arrre << ["Total: ", " Points"]
				arrre << ["Total Distance: ", " Laps", true]
				arrre << ["Total Pieces: ", ""]

			# Jump course
			when "Jump"

				eventname = ["Lamp Jump", "Disc Catch", "Hurdle Dash"]

				# Random number - I don't have events. So, I use random
				# Lamp Jump
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << rand(350)
						score << (scorein[i] / 3.5).round
					}
					[score, miss, scorein, individual]
				}

				# Disc Catch
				arrpr << proc {
					scorein = []
					score = []
					miss = []
					individual = []
					12.times {
						miss << rand(5)
						individual << rand(5) # This method isn't right. This is achievements of each pokemon
					}
					4.times { |i|
						scorein << rand(40)
						score << (30 + (120 * scorein[i]) / (12.5 + scorein[i]))
					}
					[score, miss, scorein, individual]
				}

				# Hurdle Dash
				arrpr << proc { Pokeathlon.minigame_hurdle_dash(@store[:species], @store[:id]) }

				# Show string (unit, total) in result scene
				arrre << ["Total: ", " Points"]
				arrre << ["Total: ", " Points"]
				arrre << ["Total Time: ", " Seconds", true, true]

			end

			# Play event
			general_3_events(eventname, arrpr, arrre)

			# Finish course
		end

		# Make player turn up/ turn down
		def player_turn_up_down(num, down=false)
			h = @sprites["candidat #{num}"].src_rect.height
			y = h * (down ? 0 : 3)
			set_src_xy_sprite("candidat #{num}", 0, y)
		end

	end
end