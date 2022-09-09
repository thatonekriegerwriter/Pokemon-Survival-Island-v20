module ContestHall
	class Show

		#------------#
		# Show heart #
		#------------#
		def show_heart_vote(poke, map)
			index  = DIFFICULT.index(@difficulty)
			rate   = [60, 120, 180, 240][index]
			number = [poke.cool, poke.beauty, poke.cute, poke.smart, poke.tough][@contest[:number]]
			# ID of event need to show heart in event
			id = []
			# Normal
			id << [7, 8, 9, 10, 11, 12]
			# Super
			id << [14, 15, 16, 17] if index >= 1
			# Hyper
			id << [18, 19] if index >= 2
			# Master
			id << [20, 21, 22, 23, 24, 25] if index >= 3
			id = id.flatten
			size = id.size
			if number > rate
				id.each { |d| self.set_switch(map, d, 'A') }
			else
				distance = size
				loop do
					distance -= 1
					break if number.between?((rate/size*distance).to_f, (rate/size*(distance+1)).to_f)
				end
				return if distance.zero?
				distance.times { |i| self.set_switch(map, id[i], 'A') }
			end
		end

		#--------------------#
		# Before choose move #
		#--------------------#
		def before_choose_move
			return if @process != 0
			@atself = false
			@priorhearts = 0
			file = 
				case @round
				when 1 then "Roundone"
				when 2 then "Roundtwo"
				when 3 then "Roundthree"
				when 4 then "Roundfour"
				when 5 then "Roundfive"
				end
			create_sprite("Round", file, @viewport)
			pbWait(5)
			10.times { |i|
				[0, 1, 4, 5, 8, 9].include?(i) ? (@sprites["Round"].y += 6) : (@sprites["Round"].y -= 6)
				pbWait(2)
			}
			dispose(@sprites, "Round")
			choose_move # Choose
			@process = 1
		end
		
		#-------------#
		# Choose move #
		#-------------#
		def choose_move
			# Move
			create_sprite("moves", "moves", @viewport) if !@sprites["moves"]
			set_xy_sprite("moves", 0, 197)
			@sprites["moves"].z = 9
			# Set overlay
			create_sprite_2("overlay",  @viewport) if !@sprites["overlay"]
			create_sprite_2("overlay1", @viewport) if !@sprites["overlay1"]
			@sprites["overlay"].z = 10
			@sprites["overlay1"].z = 10
			overlay  = @sprites["overlay"].bitmap
			overlay1 = @sprites["overlay1"].bitmap
			overlay.clear
			overlay1.clear
			pbSetSmallFont(overlay)
			textpos  = [[_INTL("Please select a move."), 12, 165, 0, Color.new(256,256,256), Color.new(0,0,0)]]
			imagepos = []
			textpos1 = []
			yPos = 195
			xPos = 10
			selectYPos = 200
			# Draw select bar
			create_sprite("selectbar", "contestselect", @viewport) if !@sprites["selectbar"]
			set_xy_sprite("selectbar", 7, selectYPos)
			@sprites["selectbar"].z = 10
			# Draw text
			@selection = 0
			# Move
			data     = SetContestMoves.r_move
			position = data[:id].index(@pkmn1.moves[@selection].id)
			@selectedmove = @pkmn1.moves[@selection].id
			description   = data[:description][position]
			hearts        = data[:heart][position]
			jam           = data[:jam][position]
			file = "Graphics/Pictures/Contest/negaheart#{jam}"
			@sprites["selectjam"] = IconSprite.new(400, 232, @viewport) if !@sprites["selectjam"]
			@sprites["selectjam"].setBitmap(file)
			@sprites["selectjam"].z = 10
			file = "Graphics/Pictures/Contest/heart#{hearts}"
			@sprites["selecthearts"] = IconSprite.new(400, 197, @viewport) if !@sprites["selecthearts"]
			@sprites["selecthearts"].setBitmap(file)
			@sprites["selecthearts"].z = 10
			if @pkmn1.moves[@selection].id
				name = @pkmn1.moves[@selection].name
				textpos1 << [name, 245, 200, 0, Color.new(256,256,256), Color.new(0,0,0)]
				pbDrawTextPositions(overlay1, textpos1)
			end
			drawTextEx(overlay1, 245, 250, 255, 2, description, Color.new(256,256,256), Color.new(0,0,0))
			@pkmn1.numMoves.times { |i|
				if @pkmn1.moves[i].id
					@selectedmove = @pkmn1.moves[i].id
					position = data[:id].index(@selectedmove)
					name = ["Cool", "Beauty", "Cute", "Smart", "Tough"]
					type = name.index(data[:type][position])
					imagepos << ["Graphics/Pictures/Contest/contesttype", xPos, selectYPos + 6 + 47 * i, 0, type * 28, 64, 28]
					name = data[:name][position]
					colorb = @pkmn1lastmove && name == @pkmn1lastmove ? 175 : 256
					textpos << [name, xPos + 70, yPos + 10, 0, Color.new(colorb, colorb, colorb), Color.new(0,0,0)]
				else
					textpos << ["-", 316, yPos, 0, Color.new(256,256,256), Color.new(0,0,0)]
				end
				yPos += 44
			}
			pbDrawTextPositions(overlay, textpos)
			pbDrawImagePositions(overlay, imagepos)
		end

		#--------------------------------------#
		# Rewrite name when player press input #
		#--------------------------------------#
		def set_name_move
			selectYPos = @selection * 47 + 200
			@sprites["selectbar"].y = selectYPos
			data     = SetContestMoves.r_move
			position = data[:id].index(@pkmn1.moves[@selection].id)
			@selectedmove = @pkmn1.moves[@selection].id
			description   = data[:description][position]
			hearts        = data[:heart][position]
			jam           = data[:jam][position]
			file = "Graphics/Pictures/Contest/negaheart#{jam}"
			@sprites["selectjam"].setBitmap(file)
			file = "Graphics/Pictures/Contest/heart#{hearts}"
			@sprites["selecthearts"].setBitmap(file)
			overlay1 = @sprites["overlay1"].bitmap
			overlay1.clear
			textpos1 = []
			name = data[:name][position]
			textpos1 << [name, 245, 200, 0, Color.new(256, 256, 256), Color.new(0,0,0)]
			drawTextEx(overlay1, 245, 250, 255, 2, description, Color.new(256, 256, 256), Color.new(0, 0, 0))
			pbDrawTextPositions(overlay1, textpos1)
		end

		#-----------#
		# Set input #
		#-----------#
		def set_input
			return if @process != 1
			if checkInput(Input::DOWN)
				@selection += 1
				@selection  = 0 if @selection >= @pkmn1.numMoves
				# Set information
				set_name_move
			elsif checkInput(Input::UP)
				@selection -= 1
				@selection  = @pkmn1.numMoves - 1 if @selection < 0
				# Set information
				set_name_move
			elsif checkInput(Input::USE)
				# Set select (move)
				@moveselection = @selection
				# Dispose
				["selecthearts", "moves", "selectbar", "selectjam"].each { |sprite| dispose(@sprites, sprite) }
				["overlay", "overlay1"].each { |i| clearTxt(i) }
				@process = 2
			end
		end

		#--------------------------#
		# Pokemon starts animation #
		#--------------------------#
		def first_pokemon_play
			# Set bitmap
			create_sprite_2("overlay",  @viewport) if !@sprites["overlay"]
			pbSetSystemFont(@sprites["overlay"].bitmap)
			display_fastest
			file  = "Graphics/Pictures/Contest/choice 29"
			width = 340
			pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Alright {1}, let's see what you can do!", @pokeorder[0].name), file, nil, width)
			# Set move
			set_move_AI(@position_pkmn)
			pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now onto the next pokemon!",@pokeorder[0].name), file, nil, width)
			@nvcrowd = false if @nvcrowd
			dispose(@sprites, "pokemon1") # Dispose
			pbWait(3)
			@process = 3
		end

		def next_pokemon_play
			file  = "Graphics/Pictures/Contest/choice 29"
			width = 340
			pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Next up we have {1}!",@pokeorder[@position_pkmn].name), file, nil, width)
			display_pkmn_fast(@position_pkmn)
			pbWait(2) # Wait
			# Set move
			set_move_AI(@position_pkmn)
			if @position_pkmn < 3
				pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now onto the next pokemon!",@pokeorder[@position_pkmn].name), file, nil, width)
				@nvcrowd = false if @nvcrowd
				dispose(@sprites, "pokemon#{@position_pkmn+1}")
				pbWait(3) # Wait
			else
				pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]Good job {1}, now, next round!",@pokeorder[@position_pkmn].name), file, nil, width) if @round < 5
				@nvcrowd = false if @nvcrowd
				dispose(@sprites, "pokemon#{@position_pkmn+1}")
				pbWait(3) # Wait
				# Reset
				reset_hearts
			end
			@process = 3
		end

		def process_2
			return if @process != 2
			@position_pkmn == 0 ? (first_pokemon_play) : (next_pokemon_play)
		end

		def process_3
			return if @process != 3
			@position_pkmn += 1
			@process = @position_pkmn < 4 ? 2 : 4
		end

		def process_4
			return if @process != 4
			@round += 1
			if @round > 5
				# Set order for next round
				set_order
				# Set order (reset)
				reset_order
				# Message
				file  = "Graphics/Pictures/Contest/choice 29"
				width = 340
				pbCustomMessage(_INTL("\\l[3]Judge: \\c[1]We're all out of Appeal Time!"), file, nil, width)
				@exit = true
			else
				# Set order for next round
				set_order
				# Set order (reset)
				reset_order
				# Set position
				@position_pkmn = 0
				# Set process
				@process = 0 # Next round
			end
		end

	end
end