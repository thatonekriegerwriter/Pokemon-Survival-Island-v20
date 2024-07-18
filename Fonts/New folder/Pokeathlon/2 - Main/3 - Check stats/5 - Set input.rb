module Pokeathlon
	class CheckStats

		def set_input_up_down
			if checkInput(Input::UP)
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
				@pkmn[:name]  = $player.party[index]
				# Cry
				GameData::Species.play_cry(@pkmn[:name]) if change != @pkmn[:index]
			elsif checkInput(Input::DOWN)
				change = @pkmn[:index]
				index  = @pkmn[:index]
				loop do
					index += 1
					if index == @pkmn[:size]
						index = @pkmn[:size] - 1
						break
					else
						if @pkmn[:party][index]
							break
						else
							if index == @pkmn[:size]
								index = @pkmn[:index]
								break
							end
						end
					end
				end
				@pkmn[:index] = index
				@pkmn[:name]  = $player.party[index]
				# Cry
				GameData::Species.play_cry(@pkmn[:name]) if change != @pkmn[:index]
			end
		end
		
		def set_input_check
			@exit = true if checkInput(Input::BACK)
			# Up/Down
			set_input_up_down
		end

	end
end