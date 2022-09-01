module ContestHall
	class Show
		
		# Define max value of pokemon (specie)
		def specie_max_value
			species = []
			GameData::Species.each { |s| species << s.id if s.form == 0 }
			return species
		end

		#---------------------#
		# Set pokemon to play #
		#---------------------#
		def set_pokemon(pkmn2, pkmn3, pkmn4, move2, move3, move4, name2, name3, name4)
			# Set pokemon
			@pkmn1 = $Trainer.party[@contest[:pospkmn]]
			specie = specie_max_value
			# Player set
			if SET_MYSELF
				if [pkmn2, pkmn3, pkmn4].include?(nil)
					p "You need to set Pokemon if you want to use SET_MYSELF"
					Kernel.exit!
				end
				opponent = [pkmn2, pkmn3, pkmn4]
			# Random
			elsif RANDOM_POKEMONS
				opponent = [specie.sample, specie.sample, specie.sample]
				# Not same
				if !SIMILAR_POKEMONS
					loop do
						break if opponent.uniq.size == 3 && !opponent.include?(@pkmn1.species)
						opponent = [specie.sample, specie.sample, specie.sample]
					end
				end
			# Choose
			else
				if EACH_CONTEST
					list = [POKEMON_COOL, POKEMON_BEAUTY, POKEMON_CUTE, POKEMON_SMART, POKEMON_TOUGH]
					list = list[@contest[:number]]
				else
					list = POKEMON_CONTEST
				end
				cant = false
				list.each { |l|
					if l.size <= 3
						cant = true
						break
					end
					l.each { |n|
						next if n.is_a?(Symbol)
						p "You should rewrite Pokemons in Constant."
						Kernel.exit!
					}
				}
				cant = true if list.size != 3
				if cant
					p "You should add more Pokemons in Constant."
					Kernel.exit!
				end
				# Random to choose
				opponent = []
				list.each { |l| opponent << l.sample }
				# Not same
				if !SIMILAR_POKEMONS
					loop do
						break if opponent.uniq.size == 3
						opponent = []
						list.each { |l| opponent << l.sample }
					end
				end
			end
			# Set to introduce
			@opponent1 = opponent[0]
			@opponent2 = opponent[1]
			@opponent3 = opponent[2]
			# Set level
			if SET_LEVEL_CONTEST
				level = [LEVEL_POKEMON_CONTEST_NORMAL, LEVEL_POKEMON_CONTEST_SUPER, LEVEL_POKEMON_CONTEST_HYPER, LEVEL_POKEMON_CONTEST_MASTER][@ribbonnum%4-1]
			else
				level  = []
				fakelv = [25, 50, 75, 100]
				3.times { |i| level << fakelv[@ribbonnum%4-1] }
			end
			# Set pokemon (other)
			@pkmn2 = Pokemon.new(opponent[0], level[0])
			@pkmn3 = Pokemon.new(opponent[1], level[1])
			@pkmn4 = Pokemon.new(opponent[2], level[2])
			# Set moves if you set
			if move2.is_a?(Array)
				move2.each_with_index { |m, i| @pkmn2.learn_move(m) }
			elsif move3.is_a?(Array)
				move3.each_with_index { |m, i| @pkmn3.learn_move(m) }
			elsif move4.is_a?(Array)
				move4.each_with_index { |m, i| @pkmn4.learn_move(m) }
			end
			# Set name (for pokemon)
			if name2.is_a?(String) && name2 != "" && name2.length < 16
				@pkmn2.name = name2
			elsif name3.is_a?(String) && name3 != "" && name3.length < 16
				@pkmn3.name = name3
			elsif name4.is_a?(String) && name4 != "" && name4.length < 16
				@pkmn4.name = name4
			end
			# Set new value
			set_continue_value_init
		end

		#-----------#
		# Set value #
		#-----------#
		def set_continue_value_init
			# Number
			@pkmn1total = 0
			@pkmn2total = 0
			@pkmn3total = 0
			@pkmn4total = 0
			# Check double
			@pkmn1DoubleNext = false
			@pkmn2DoubleNext = false
			@pkmn3DoubleNext = false
			@pkmn4DoubleNext = false
			# Check miss
			@pkmn1MissTurn = false
			@pkmn2MissTurn = false
			@pkmn3MissTurn = false
			@pkmn4MissTurn = false
			# Check move?
			@pkmn1nomoremoves = false
			@pkmn2nomoremoves = false
			@pkmn3nomoremoves = false
			@pkmn4nomoremoves = false
			# Applause
			@applause = 0
			# Star
			@pkmn1stars = 0
			@pkmn2stars = 0
			@pkmn3stars = 0
			@pkmn4stars = 0
			@stars=[@pkmn1stars, @pkmn2stars, @pkmn3stars, @pkmn4stars]
			# Heart
			@pkmn1hearts = 0
			@pkmn2hearts = 0
			@pkmn3hearts = 0
			@pkmn4hearts = 0
			# Set round
			@round = 1
			@position_pkmn = 0
		end

		#---------------#
		# Set condition #
		#---------------#
		def create_condition
			random = []
			5.times { |i|
				case DIFFICULT.index(@difficulty)
				when 0 then random << (10 + rand(51))
				when 1 then random << (10 + rand(111))
				when 2 then random << (10 + rand(171))
				when 3 then random << (10 + rand(231))
				end
			}
			@pkmn2.cool = @pkmn2.beauty = @pkmn2.cute = @pkmn2.smart = @pkmn2.tough = random[0]
			@pkmn3.cool = @pkmn3.beauty = @pkmn3.cute = @pkmn3.smart = @pkmn3.tough = random[1]
			@pkmn4.cool = @pkmn4.beauty = @pkmn4.cute = @pkmn4.smart = @pkmn4.tough = random[2]
			# Sort
			sort_poke_base_number
		end

		#--------------------------------#
		# Presentation (Introduce event) #
		#--------------------------------#
		def presentation_pokemon
			map =  MAP_ID[DIFFICULT.index(@difficulty)]
			# MC
			self.set_switch(map, 6)
			name = 
				case DIFFICULT.index(@difficulty)
				when 0 then "Normal"
				when 1 then "Super"
				when 2 then "Hyper"
				when 3 then "Master"
				end
			if @contestType == "Beauty"
				pbMessage(_INTL("MC: Hello! We're just getting started with a {1} Rank Pokemon {2} Contest.", name, @contestType))
			else
				pbMessage(_INTL("MC: Hello! We're just getting started with a {1} Rank Pokemon {2}ness Contest.", name, @contestType))
			end
			pbMessage(_INTL("The participating Trainers and their Pokemon are as follows:"))
			self.set_switch(map, 6, 'B')
			# Introduce pokemon
			self.set_switch(map, 2, 'A')
			# First
			pbMessage(_INTL("Entry No.1"))
			introduce_specie(@opponent1, @pkmn2, @pkmn2.name, map)
			pbWait(10)
			self.set_switch(map, 2, 'B')
			self.set_switch(map, 1, 'A')
			pbWait(15)
			# Second
			pbMessage(_INTL("Entry No.2"))
			introduce_specie(@opponent2, @pkmn3, @pkmn3.name, map)
			pbWait(10)
			self.set_switch(map, 1, 'B')
			self.set_switch(map, 3, 'A')
			pbWait(15)
			# Third
			pbMessage(_INTL("Entry No.3"))
			introduce_specie(@opponent3, @pkmn4, @pkmn4.name, map)
			pbWait(10)
			self.set_switch(map, 3, 'B')
			# Move map
			pbScrollMap(2, 2, 3)
			pbScrollMap(6, 3, 3)
			self.set_switch(map, 4, 'B')
			pbWait(15)
			# Player
			$game_self_switches[[map, 4, 'A']] = true
			player = @pkmn1.species
			introduce_specie(player, @pkmn1, @pkmn1.name, map)
			pbWait(10)
			self.set_switch(map, 4, 'C')
			$game_self_switches[[map, 4, 'A']] = true
			# Move map
			pbScrollMap(4, 3, 3)
			pbScrollMap(8, 2, 3)
			# MC
			pbMessage(_INTL("MC: We're just seen the four Pokemon contestants. Now it's time for primary judging!"))
			pbMessage(_INTL("The audience will vote on their favorite Pokemon contestants. Without any further ado, let the voting begin!"))
			pbMessage(_INTL("Voting under way..."))
			pbWait(20)
			pbMessage(_INTL("Voting is now complete!"))
			pbMessage(_INTL("While the votes are being tallied, let's move on to secondary judging!"))
			pbMessage(_INTL("The second stage of judging is the much anticipated appeal time!"))
			pbMessage(_INTL("May the contestants amaze us with superb appeals of dazzling moves!"))
			pbMessage(_INTL("Let's see a little enthusiasm! Let's appeal!"))
			self.set_switch(map, 6, 'C')
			self.set_switch(map, 5, 'A')
			pbWait(5)
		end

		#-------#
		# Scene #
		#-------#
		def create_scene
			create_sprite("background", "contestbg", @vp1)
			create_sprite("message", "mess", @viewport)
			@sprites["message"].z = 2
			@sprites["message"].y = @sprites["background"].src_rect.height - 128
			create_sprite("list", "list", @viewport)
			@sprites["list"].x = @sprites["background"].bitmap.width - 165
			# Invisible sprite to serve as target for animations
			create_sprite("opponent", "000", @viewport)
			ox = @sprites["opponent"].src_rect.width / 2
			oy = @sprites["opponent"].src_rect.height / 2
			set_oxoy_sprite("opponent", ox, oy)
			set_xy_sprite("opponent", ox, oy)
		end

	end
end