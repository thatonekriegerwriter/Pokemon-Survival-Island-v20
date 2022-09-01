module Pokeblock
	class Show

		def set_input
			input_page_pokeblock
			input_page_pkmn
		end

		#-------------------------------#
		# Input up/down in page Pokemon #
		#-------------------------------#
		def input_up_down_pkmn
			if checkInput(Input::UP)
				if @cancelButton
					@cancelButton = false
				else
					change = @pkmn[:index]
					index  = @pkmn[:index]
					loop do
						index -= 1
						if index < 0
							index = 0
							break
						else
							if @pkmn[:party][index]
								break
							else
								if index == 0
									index = @pkmn[:index]
									break
								end
							end
						end
					end
					@pkmn[:index] = index
					@pkmn[:name]  = $Trainer.party[index]
					# Cry
					GameData::Species.play_cry(@pkmn[:name]) if change != @pkmn[:index]
				end
			elsif checkInput(Input::DOWN)
				change = @pkmn[:index]
				index  = @pkmn[:index]
				loop do
					index += 1
					if index == @pkmn[:size]
						index = @pkmn[:size] - 1
						@cancelButton = true
						break
					else
						if @pkmn[:party][index]
							break
						else
							if index == @pkmn[:size]
								index = @pkmn[:index]
								@cancelButton = true
								break
							end
						end
					end
				end
				@pkmn[:index] = index
				@pkmn[:name]  = $Trainer.party[index]
				# Cry
				GameData::Species.play_cry(@pkmn[:name]) if change != @pkmn[:index]
			end
		end

		#--------------------#
		# Input page Pokemon #
		#--------------------#
		def input_page_pkmn
			if @style == 0
				return if @processPkBlock == 2
				# Press Use
				if checkInput(Input::USE)
					change = true
					if @processPkBlock == 0
						@processPkBlock = 1
					elsif @processPkBlock == 1
						if @cancelButton
							@processPkBlock = 0
						else
							if @pkmn[:name].sheen >= 255
								change = false
								pbMessage(_INTL("This pokemon can't eat anymore"))
							else
								@processPkBlock = 2
							end
						end
					end
					# Fade
					fade_in if change
				# Press Back
				elsif checkInput(Input::BACK)
					if @processPkBlock == 0
						@exit = true
					else
						# Fade
						fade_in
						@processPkBlock = 0
						# Reset
						@flavorPos = 0
						$Trainer.party.each_with_index { |pkmn, i|
							next if pkmn.egg? || !pkmn.able?
							@pkmn[:name]  = pkmn
							@pkmn[:index] = i
							break
						}
					end
				end
				# Up / Down
				input_up_down_pkmn if @processPkBlock == 1
			else
				@exit = true if checkInput(Input::BACK) || (checkInput(Input::USE) && @cancelButton)
				# Up / Down
				input_up_down_pkmn
			end
		end

		#----------------------#
		# Input page Pokeblock #
		#----------------------#
		def input_page_pokeblock
			return if @style != 0
			return if @processPkBlock != 0
			if checkInput(Input::UP)
				@flavorPos -= 1
				@flavorPos  = 0 if @flavorPos < 0
			elsif checkInput(Input::DOWN)
				@flavorPos += 1
				@flavorPos  = @flavor.size - 1 if @flavorPos >= @flavor.size
			end
		end

	end
end