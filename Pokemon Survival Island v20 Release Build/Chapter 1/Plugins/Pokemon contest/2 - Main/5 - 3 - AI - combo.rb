module ContestHall
	class Show
		
		#-------#
		# Combo #
		#-------#
		# Old: pbCheckforCombos
		# CONTESTCOMBOS are defined in the bottom of this script
		def check_combos
			arr      = [@pkmn1lastmove, @pkmn2lastmove, @pkmn3lastmove, @pkmn4lastmove]
			position = position_arr_pkmn
			oldmove  = arr[position]
			# Check Combo
			CONTESTCOMBOS.each_with_index { |combo, i|
				next unless oldmove == combo[0]
				combo.each_with_index { |cb, j|
					next if j == 0
					return true if @currentmovename == cb
				}
			}
			return false
		end

		#----#
		# AI #
		#----#
		# Old: pbAI
		def set_ai(pokemon, difficulty)
			movescores = []
			nummoves   = pokemon.numMoves - 1
			data       = SetContestMoves.r_move
			(0...nummoves).each { |i|
				score = 100
				move  = pokemon.moves[i].id
				currentmovename = pokemon.moves[i].name
				if pokemon.moves[i].id
					move = data[:id].index(move) # Position
					hearts   = data[:heart][move]
					jam      = data[:jam][move]
					function = data[:function][move]
					type     = data[:type][move]
					case function
					# No function
					when 0 then score += (hearts > 3 ? 60 : 30)
					# Gains oblivious. Increase score for earlier position
					when 1, 2
						case @currentpos
						when 1 then score += 60
						when 2 then score += 40
						when 4 then score -= 20
						end
					# Move Up in order
					when 3 then score += (@currentpos == 4 ? 30 : 10)
					# Ups condition    
					when 4 then score += 30
					# Tries to startle previous pokemons
					when 5
						case @currentpos
						when 4 then score += 70
						when 3 then score += 40
						when 1 then score -= 20
						end
					# Works better later
					when 6, 23   
						case @currentpos
						when 4 then score += 70
						when 3 then score += 40
						when 1 then score -= 20
						end
					# Deducts from pokemon that has judges attention
					when 7 then @currentpos.times { |k| score += 30 if @hasattention[k] }
					# Startles pokemon in front
					when 8  
						case @currentpos
						when 4 then score += 40
						when 3 then score += 20
						when 1 then score -= 20
						end
					# Better if previous move was better
					when 9, 40
						score += 60 if @priorhearts >= 3
						score -= 20 if @priorhearts  < 3
					# Easily startled
					when 10   
						case @currentpos
						when 4 then score += 60
						when 3 then score += 40
						when 1 then score -= 20
						end
					# Move down in order
					when 11
						case @currentpos
						when 4 then score -= 20
						else score += 20
						end
					# Startles pokemon with good appeals    
					when 12 
						case @currentpos
						when 4
							score += 20
							score += 30 if @priorhearts > 3
						when 3
							score += 10
							score += 30 if @priorhearts > 3
						when 1 then score -= 20
						end
					# Stops crowd excitement
					when 13
						score -= 20 if @applause  > 3
						score += 20 if @applause <= 3
					# Works best if performed first
					when 14 then score += 60 if @currentpos == 1
					# Can be used multiple times without boring judge
					when 15 then score += 20
					# Jams pokemon and misses turn
					when 16  
						case @currentpos
						when 4 then score += 30
						when 3 then score += 20
						end
						case @round
						when 5 then score += 60
						when 1 then score -= 10
						end
					# Makes all pokemon after nervous
					when 17  
						case @currentpos
						when 1 then score += 60
						when 2 then score += 40
						when 4 then score -= 20
						end
					# No more moves
					when 18 then @round == 5 ? (score += 90) : (score -= 60)
					# Depends on applause level
					when 19 then score += 20 if @applause > 2
					# Depends on random
					when 20 then score += 20
					# Best if performed last
					when 21 then score += 60 if @currentpos == 4
					# Removes a star
					when 22, 32 then score += 40 if @currentpos == 4 && @stars.max > 1 && @stars.index(@stars.max) != (@currentpos - 1)
					# Scramble
					when 24 then score += 30 if @round != 5
					# Works better if last move type is the same
					when 25 then @lastmoveType && type == @lastmoveType ? (score += 40) : (score -= 10)
					# Appeal later next turn
					when 26 then @currentpos == 4 ? (score -= 20) : (score += 20)
					# Double next turn
					when 27 then @round != 5 ? (score += 40) : (score -= 60)
					# Random amounts
					when 28 then score += 20
					# Better if last pokemon's wasn't
					when 29 then @priorhearts < 3 ? (score += 60) : (score -= 20)
					# Half as much as previous pokemon
					when 30 then score += @priorhearts / 2.to_f * 10 if @priorhearts
					# Gets crowd going
					when 31 then score += 40
					# Better based on crowd excitement
					when 33, 41 then score += (@applause * 10).to_f
					# Same amount as last appearl
					when 34, 37 then score += @priorhearts.to_f * 10 if @priorhearts
					# Equals the pokemon's stars
					when 35 then @stars[@currentpos-1] > 0 ? (score += @stars[@currentpos-1] * 10) : (score -= 30)
					when 36 then type == @contestType ? (score += 40) : (score -= 10)
					# Better for lower applause
					when 38  
						case @applause
						when 1 then score += 60
						when 2 then score += 40
						when 3 then score += 20
						when 4 then score -= 20
						end  
					# Better for later rounds
					when 39  
						case @round
						when 5 then score += 60
						when 3 then score += 40
						when 2 then score += 20
						when 1 then score -= 20
						end
					end
					# Better if it's the same type as the contest
					score += 60 if type == @contestType
					@currentmovename = currentmovename
					# Better if it will result in a combo
					score += 60 if @round > 1 && check_combos 
					score -= 60 if @round > 1 && function != 15 && check_last
				end
				movescores.push(score) if pokemon.moves[i].id
			}
			# Movescores have been added up. Now find highest value, with a bit of variation
			stdev = pbStdDev(movescores)
			# Finds highest scoring move
			choice    = movescores.index(movescores.max)
			notchoice = movescores.index(movescores.min)
			# Use the highest scoring move if it's clearly better (stdev of 100 or more)
			return choice if stdev >= 100 && rand(10) != 0  
			newmovescores = movescores.clone
			newmovescores.sort
			secondlowest = movescores.index(newmovescores[1])
			r = rand(movescores.length)
			movescores[notchoice]    = nil if difficulty > 25
			movescores[secondlowest] = nil if difficulty > 75
			# Lowest difficulty
			if difficulty > 25
				return r if !movescores[r].nil? && rand(10) > 4
			elsif difficulty > 50
				return r if !movescores[r].nil? && rand(10) > 2
			elsif difficulty > 75
				2.times { return r if !movescores[r].nil? && rand(10) > 2 }
			else
				return r
			end
		end

		def pbStdDev(choices)
			sum = 0
			n   = 0
			choices.each do |c|
				sum += c
				n   += 1
			end
			return 0 if n < 2
			mean = sum.to_f / n.to_f
			varianceTimesN = 0
			choices.each do |c|
				next if c <= 0
				deviation = c.to_f - mean
				varianceTimesN += deviation*deviation
			end
			# Using population standard deviation
			# [(n-1) makes it a sample std dev, would be 0 with only 1 sample]
			return Math.sqrt(varianceTimesN/n)
		end

		#----------------#
		# Set move of AI #
		#----------------#
		def set_move_AI(number)
			@currentpos  = number + 1
			@currentpoke = @pokeorder[number]
			# Determine which move to use
			# Pokemon owner : AI for opponents
			i = @currentpoke == @pkmn1 ? @moveselection : set_ai(@pokeorder[number], @difficulty)
			movedata = GameData::Move.get(@pokeorder[number].moves[i].id)
			if movedata.id_number <= 0
				movedata = GameData::Move.get(@pokeorder[number].moves[0].id)
				i = 0
			end
			data     = SetContestMoves.r_move
			position = data[:id].index(@pokeorder[number].moves[i].id)
			@currentmovename = @pokeorder[number].moves[i].name
			pbWait(2)
			@currentmove  = data[:id][position]
			@currentmove1 = data[:id][position]
			@atself = movedata.target == GameData::Target.get(:User)
			@currenthearts = data[:heart][position]
			type           = data[:type][position]
			move_type(type)
			file  = "Graphics/Pictures/Contest/choice 29"
			width = 340
			# Skip the move processing if nomore moves is true
			if !no_more
				# Skip move processing if it misses this turn
				if !miss_turn
					# Check for double hearts
					if double_next
						@currenthearts *= 2
						reverse_double_next
					end
					if @nervous[@currentpos-1]
						pbCustomMessage(_INTL("\\l[3]{1} is nervous.", @pokeorder[number].name), file, nil, width)
						# Check for nervousness, 30% chance
						random = rand(100)
						if random < 30                                                   
							pbCustomMessage(_INTL("\\l[3]{1} was too nervous to move!",@pokeorder[number].name), file, nil, width)
							@nvcrowd = true
						else
							pbCustomMessage(_INTL("\\l[3]{1} used {2}!", @pokeorder[number].name,@currentmovename), file, nil, width)
							animation(@currentmove1, 0)
							func_adjust_hearts
							display_positive_hearts
						end
					else
						pbCustomMessage(_INTL("\\l[3]{1} used {2}!", @pokeorder[number].name,@currentmovename), file, nil, width)
						animation(@currentmove1, 0)
						func_adjust_hearts  
						display_positive_hearts
					end
				else
					# Change miss turn variable back after missing turn
					reverse_miss_turn
				end
			end
			# Check
			if check_last && @currentfunction != 15 && @round != 1 && !no_more && !miss_turn
				@currenthearts -= 1
				pbCustomMessage(_INTL("\\l[3]The judge looked at {1} expectantly!", @pokeorder[@currentpos-1].name), file, nil, width)
				set_jam(1, @pokeorder[@currentpos-1])
				decrease_hearts(@currentpoke, @currentpos, "notnil")
			end
			if @round != 1 && check_combos
				@currenthearts = 5
				pbCustomMessage(_INTL("\\l[3]{1} really caught the judges attention!", @pokeorder[@currentpos-1].name), file, nil, width)
				display_positive_hearts
				decrease_star_graphic(@currentpos - 1, 1, false)
			end
			assign_last_move
			@lastmoveType = @moveType
			# Crowd
			crowd unless @nvcrowd
			pbWait(3)
		end

	end
end