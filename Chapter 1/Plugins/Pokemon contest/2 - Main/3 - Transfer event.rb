module ContestHall
	class Transfer < NewMethod

		# NPC
		def choose
			return if $Trainer.party.size <= 0
			pbMessage(_INTL("Hello!"))
      pbMessage(_INTL("This is the reception counter for Pokemon Contest."))
			choice = [_INTL("Enter"),_INTL("Cancel")]
      choose = pbMessage(_INTL("Would you like to enter your Pokemon in our Contest?"),choice,-1)
      case choose
			# Enter
			when 0
				choice2 = [_INTL("Coolness Contest"), _INTL("Beauty Contest"), _INTL("Cuteness Contest"), _INTL("Smartness Contest"), _INTL("Toughness Contest"), _INTL("Exit")]
				choose2 = pbMessage(_INTL("Which Contest would you like to enter?"), choice2, -1)
				case choose2
				when 0, 1, 2, 3, 4 then self.choose_rank(choose2)
				else pbMessage(_INTL("We hope you will participate another time."))
				end
			# Exit
			else pbMessage(_INTL("We hope you will participate another time."))
			end
		end

		# Choose pokemon
		def choose_rank(types)
			choice = [_INTL("Normal Rank"), _INTL("Super Rank"), _INTL("Hyper Rank"), _INTL("Master Rank"), _INTL("Exit")]
			choose = pbMessage(_INTL("Which Rank would you like to enter?"), choice, -1)
			case choose
			when 0, 1, 2, 3 then type = (choose + 1) + 4 * types # Number of ribbon: 1,2,3,...,18
			else
				pbMessage(_INTL("We hope you will participate another time."))
				return
			end
			# Choose pokemon
			able = 
				if (type - 1) % 4 == 0
					proc { |poke| !poke.egg? && !(poke.isShadow? rescue false)}
				else
					proc { |poke| !poke.egg? && !(poke.isShadow? rescue false) && poke.hasRibbon?(type-1)}
				end
			finish = false
			process = 0
			chosen = 0
			loop do
				break if finish
				case process
        when 0
					# Screen to choose
          pbFadeOutIn {
						scene = PokemonParty_Scene.new
						screen = PokemonPartyScreen.new(scene, $Trainer.party)
						if able
							chosen = screen.pbChooseAblePokemon(able, false)
						else
							screen.pbStartScene(_INTL("Choose a Pokémon."), false)
							chosen = screen.pbChoosePokemon
							screen.pbEndScene
						end
					}
					process = 1
        when 1
          Graphics.update
          Input.update
					# Chose
          if chosen >= 0
            if $Trainer.party[chosen].hasRibbon?(type)
              pbMessage(_INTL("Oh, but that Ribbon..."))
              pbMessage(_INTL("Your Pokemon has won this Contest before, hasn't it?"))
              if pbConfirmMessage("Would you like to enter it in this Contest anyway?")
                pbMessage(_INTL("Okay, your Pokemon will be entered in this Contest."))
                pbMessage(_INTL("Your Pokemon is Entry No.4. The Contest will begin shortly."))
								ContestHall.position_pkmn_contest(chosen)
								self.information(types, type, choose)
                finish = true
              else
                pbMessage(_INTL("Which Pokemon would you like to enter?"))
                process = 0
              end
            else
              pbMessage(_INTL("Okay, your Pokemon will be entered in this Contest."))
              pbMessage(_INTL("Your Pokemon is Entry No.4. The Contest will begin shortly."))
							ContestHall.position_pkmn_contest(chosen)
							self.information(types, type, choose)
              finish = true
            end
					# Cancel
          else
            cancel = [_INTL("Yes"),_INTL("No")]
            cancel2 = pbMessage(_INTL("Cancel participation?"), cancel, -1)
            case cancel2
						when 1 then process = 0
						else
							pbMessage(_INTL("We hope you will participate another time."))
							finish = true
            end
          end
				end
			end
		end

		# Information when player plays contest
		def information(types, type, choose)
			ContestHall.name_contest(types, type)
			# Set switch to move NPC
			self.set_switch(CONTEST_MAP_BEFORE_PLAY, CONTEST_MOVE_EVENT) # NPC
			2.times { |i| $game_self_switches[[CONTEST_MAP_BEFORE_PLAY, CONTEST_DOOR_EVENT[i], 'A']] = true } # Door
			self.set_switch(CONTEST_MAP_BEFORE_PLAY, CONTEST_MOVE_EVENT, 'B') # NPC
			2.times { |i| $game_self_switches[[CONTEST_MAP_BEFORE_PLAY, CONTEST_DOOR_EVENT[i], 'A']] = false } # Door
			self.set_switch(CONTEST_MAP_BEFORE_PLAY, CONTEST_MOVE_EVENT, 'C') # NPC
			# Set map to transfer
			map = ContestHall.map_data(choose)
			self.transfer(*map)
		end
		
	end

	def self.event_transfer = Transfer.new.choose
end