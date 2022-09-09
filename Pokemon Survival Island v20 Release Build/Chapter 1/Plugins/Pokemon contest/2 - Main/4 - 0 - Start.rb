module ContestHall
	class Show < NewMethod

		def initialize
			@sprites = {}
			@heartsprites = {}
			# Viewport
			@vp1 = Viewport.new(0,0,Graphics.width,Graphics.height)
      @vp1.z = 99999
			@vp2 = Viewport.new(0,0,Graphics.width,Graphics.height)
      @vp2.z = 99999
      @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z = 99999
			# Value
			@contest = ContestHall.r_contest
			# Set difficulty
			@difficulty = @contest[:difficult]
			# Ribbon number given if won
			@ribbonnum = @contest[:ribbon]
			# Set name contest
			@contestType = @contest[:name]
			# Nervous (No crowd)
			@nvcrowd = false
			# Case
			@order_winner = []
			@player_win = false
			@quantity_winner = 0
			# Process
			@process = 0
			# Exit
			@exit = false
		end

		def show(pkmn2, pkmn3, pkmn4, move2, move3, move4, name2, name3, name4)
			set_pokemon(pkmn2, pkmn3, pkmn4, move2, move3, move4, name2, name3, name4)
			create_condition
			presentation_pokemon
			create_scene
			pbFadeInAndShow(@sprites) { update }
			reset_order
			loop do
				# Update
				update_ingame
				break if @exit
				before_choose_move # 0
				set_input # 1
				process_2 # 2
				process_3 # 3
				process_4 # 4
			end
			pbFadeOutAndHide(@sprites) { update }
			# Clear overlay to prep for end scene
			dispose
			result_scene
		end

		# Old: showSpecies
		def introduce_specie(specie,poke,nickname,map,gender=0,form=0,shiny=false,shadow=false)
			specie = GameData::Species.get(specie).id
			name   = GameData::Species.get(specie).name
			kind   = GameData::Species.get(specie).category
			bitmap = GameData::Species.front_sprite_filename(specie,form,gender,shiny,shadow)
			GameData::Species.play_cry_from_species(specie,form)
			if bitmap # to prevent crashes
				iconwindow   = PictureWindow.new(bitmap)
				iconwindow.x = (Graphics.width - iconwindow.width) / 2
				iconwindow.y = (Graphics.height - 96 - iconwindow.height)/2
				nickname == "" ? pbMessage(_INTL("{1}. {2} POKéMON.",name,kind)) : pbMessage(_INTL("{1}. The {2} Pokémon.",nickname,kind))
				show_heart_vote(poke, map) # Show heart
				iconwindow.dispose
			else
				show_heart_vote(poke, map) # Show heart
			end
		end

	end

	def self.show(pkmn2=nil, pkmn3=nil, pkmn4=nil, move2=nil, move3=nil, move4=nil, name2=nil, name3=nil, name4=nil)
		s = Show.new
		s.show(pkmn2, pkmn3, pkmn4, move2, move3, move4, name2, name3, name4)
		s.endScene
	end

end