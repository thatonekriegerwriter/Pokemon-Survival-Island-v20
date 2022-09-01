#-----------#
# Set rules #
#-----------#
class Game_Temp
  alias battle_worm_rule add_battle_rule
  def add_battle_rule(rule, var = nil)
    rules = self.battle_rules
    case rule.to_s.downcase
    when "battle-worm" then rules["battle-worm"] = true
    else battle_worm_rule(rule,var)
    end
  end
end

module BattleWorm
	# Don't touch lines below
	@@faint   = []
	@@hp      = []
	@@status  = []
	@@percent = true
	@@random  = [false, false, false]

	module_function

	def error(str)
		p str
		Kernel.exit!
	end

	#--------#
	# Random #
	#--------#
	def random_faint  = @@random[0] = true
	def random_hp     = @@random[1] = true
	def random_status = @@random[2] = true
	def random_all    = @@random = [true, true, true]

	#-----#
	# Set #
	#-----#
	def set_faint(arr)
		self.error("You need to set faint with Array!") unless arr.is_a?(Array)
		@@faint = arr
	end

	def set_hp(arr, percent=true)
		self.error("You need to set hp with Array!") unless arr.is_a?(Array)
		@@percent = percent
		@@hp = arr
	end

	def set_status(arr)
		self.error("You need to set status with Array!") unless arr.is_a?(Array)
		@@status = arr
	end

	#-------#
	# Reset #
	#-------#
	def reset
		@@faint   = []
		@@hp      = []
		@@status  = []
		@@percent = true
		@@random  = [false, false, false]
	end

	#-----------------#
	# Set battle worm #
	#-----------------#
	def set_to_start_battle(party)
		# Create battle worm
		faint  = @@faint
		hp     = @@hp
		status = @@status
		rules  = @@random
		party2 = party.each_with_index { |pkmn, i|
			next if rules.size <= 0
			# Check faint
			if rules[0]
				if faint.size == 0
					pkmn.hp = 0 if rand == 0
				else
					pkmn.hp = 0 if faint[i]
				end
			end
			# Check hp loss
			if rules[1]
				if hp.size == 0
					pkmn.hp = rand(pkmn.totalhp) + 1
				else
					next unless hp[i]
					if @@percent
						pkmn.hp = (hp[i].is_a?(Range) ? rand(hp[i]) : hp[i]) * pkmn.totalhp / 100
					else
						pkmn.hp = hp[i].is_a?(Range) ? rand(hp[i]) : hp[i]
						pkmn.hp = pkmn.totalhp if pkmn.hp > pkmn.totalhp
						pkmn.hp = 1 if pkmn.hp < 0
					end
				end
			end
			# Check status
			if rules[2]
				if status.size == 0
					randsta = [:NONE, :SLEEP, :POISON, :BURN, :PARALYSIS, :FROZEN]
					pkmn.status = randsta.sample
				else
					pkmn.status = status[i] if status[i]
				end
			end
		}
		# Check if all pokemon fainted
		faintall = 0
		party2.each { |pkmn| faintall += 1 if pkmn.hp <= 0 }
		if faintall == party2.size && rules[0]
			party2[0].hp = 1
			party2[0].status = status[0] if rules[2] && status[0]
		end
		# Reset
		self.reset
		return party2
	end
end

#-------------#
# Wild battle #
#-------------#
alias battle_worm_wild_battle_core pbWildBattleCore
def pbWildBattleCore(*args)
	if $PokemonTemp.battleRules["battle-worm"]
		outcomeVar = $PokemonTemp.battleRules["outcomeVar"] || 1
		canLose    = $PokemonTemp.battleRules["canLose"] || false
		# Skip battle if the player has no able Pokémon, or if holding Ctrl in Debug mode
		if $player.able_pokemon_count == 0 || ($DEBUG && Input.press?(Input::CTRL))
			pbMessage(_INTL("SKIPPING BATTLE...")) if $player.pokemon_count > 0
			pbSet(outcomeVar,1)   # Treat it as a win
			$PokemonTemp.clearBattleRules
			$PokemonGlobal.nextBattleBGM       = nil
			$PokemonGlobal.nextBattleME        = nil
			$PokemonGlobal.nextBattleCaptureME = nil
			$PokemonGlobal.nextBattleBack      = nil
			pbMEStop
			return 1   # Treat it as a win
		end
		# Record information about party Pokémon to be used at the end of battle (e.g.
		# comparing levels for an evolution check)
		Events.onStartBattle.trigger(nil)
		# Generate wild Pokémon based on the species and level
		foeParty = []
		sp = nil
		for arg in args
			if arg.is_a?(Pokemon)
				foeParty.push(arg)
			elsif arg.is_a?(Array)
				species = GameData::Species.get(arg[0]).id
				pkmn = pbGenerateWildPokemon(species,arg[1])
				foeParty.push(pkmn)
			elsif sp
				species = GameData::Species.get(sp).id
				pkmn = pbGenerateWildPokemon(species,arg)
				foeParty.push(pkmn)
				sp = nil
			else
				sp = arg
			end
		end
		raise _INTL("Expected a level after being given {1}, but one wasn't found.",sp) if sp

		# Create battle worm
		foeParty = BattleWorm.set_to_start_battle(foeParty)

		# Calculate who the trainers and their party are
		playerTrainers    = [$player]
		playerParty       = $player.party
		playerPartyStarts = [0]
		room_for_partner = (foeParty.length > 1)
		if !room_for_partner && $PokemonTemp.battleRules["size"] &&
			 !["single", "1v1", "1v2", "1v3"].include?($PokemonTemp.battleRules["size"])
			room_for_partner = true
		end
		if $PokemonGlobal.partner && !$PokemonTemp.battleRules["noPartner"] && room_for_partner
			ally = NPCTrainer.new($PokemonGlobal.partner[1],$PokemonGlobal.partner[0])
			ally.id    = $PokemonGlobal.partner[2]
			ally.party = $PokemonGlobal.partner[3]
			playerTrainers.push(ally)
			playerParty = []
			$player.party.each { |pkmn| playerParty.push(pkmn) }
			playerPartyStarts.push(playerParty.length)
			ally.party.each { |pkmn| playerParty.push(pkmn) }
			setBattleRule("double") if !$PokemonTemp.battleRules["size"]
		end
		# Create the battle scene (the visual side of it)
		scene = pbNewBattleScene
		# Create the battle class (the mechanics side of it)
		battle = PokeBattle_Battle.new(scene,playerParty,foeParty,playerTrainers,nil)
		battle.party1starts = playerPartyStarts
		# Set various other properties in the battle class
		pbPrepareBattle(battle)
		$PokemonTemp.clearBattleRules
		# Perform the battle itself
		decision = 0
		pbBattleAnimation(pbGetWildBattleBGM(foeParty),(foeParty.length==1) ? 0 : 2,foeParty) {
			pbSceneStandby {
				decision = battle.pbStartBattle
			}
			pbAfterBattle(decision,canLose)
		}
		Input.update
		# Save the result of the battle in a Game Variable (1 by default)
		#    0 - Undecided or aborted
		#    1 - Player won
		#    2 - Player lost
		#    3 - Player or wild Pokémon ran from battle, or player forfeited the match
		#    4 - Wild Pokémon was caught
		#    5 - Draw
		pbSet(outcomeVar,decision)
		return decision
	else
		return battle_worm_wild_battle_core(*args)
	end
end

#----------------#
# Trainer battle #
#----------------#
alias battle_worm_trainer_battle_core pbTrainerBattleCore
def pbTrainerBattleCore(*args)
	if $PokemonTemp.battleRules["battle-worm"]
		outcomeVar = $PokemonTemp.battleRules["outcomeVar"] || 1
		canLose    = $PokemonTemp.battleRules["canLose"] || false
		# Skip battle if the player has no able Pokémon, or if holding Ctrl in Debug mode
		if $player.able_pokemon_count == 0 || ($DEBUG && Input.press?(Input::CTRL))
			pbMessage(_INTL("SKIPPING BATTLE...")) if $DEBUG
			pbMessage(_INTL("AFTER WINNING...")) if $DEBUG && $player.able_pokemon_count > 0
			pbSet(outcomeVar,($player.able_pokemon_count == 0) ? 0 : 1)   # Treat it as undecided/a win
			$PokemonTemp.clearBattleRules
			$PokemonGlobal.nextBattleBGM       = nil
			$PokemonGlobal.nextBattleME        = nil
			$PokemonGlobal.nextBattleCaptureME = nil
			$PokemonGlobal.nextBattleBack      = nil
			pbMEStop
			return ($player.able_pokemon_count == 0) ? 0 : 1   # Treat it as undecided/a win
		end
		# Record information about party Pokémon to be used at the end of battle (e.g.
		# comparing levels for an evolution check)
		Events.onStartBattle.trigger(nil)
		# Generate trainers and their parties based on the arguments given
		foeTrainers    = []
		foeItems       = []
		foeEndSpeeches = []
		foeParty       = []
		foePartyStarts = []
		for arg in args
			if arg.is_a?(NPCTrainer)
				foeTrainers.push(arg)
				foePartyStarts.push(foeParty.length)
				arg.party.each { |pkmn| foeParty.push(pkmn) }
				foeEndSpeeches.push(arg.lose_text)
				foeItems.push(arg.items)
			elsif arg.is_a?(Array)   # [trainer type, trainer name, ID, speech (optional)]
				trainer = pbLoadTrainer(arg[0],arg[1],arg[2])
				pbMissingTrainer(arg[0],arg[1],arg[2]) if !trainer
				return 0 if !trainer
				Events.onTrainerPartyLoad.trigger(nil,trainer)
				foeTrainers.push(trainer)
				foePartyStarts.push(foeParty.length)
				trainer.party.each { |pkmn| foeParty.push(pkmn) }
				foeEndSpeeches.push(arg[3] || trainer.lose_text)
				foeItems.push(trainer.items)
			else
				raise _INTL("Expected NPCTrainer or array of trainer data, got {1}.", arg)
			end
		end

		# Create battle worm
		foeParty = BattleWorm.set_to_start_battle(foeParty)

		# Calculate who the player trainer(s) and their party are
		playerTrainers    = [$player]
		playerParty       = $player.party
		playerPartyStarts = [0]
		room_for_partner = (foeParty.length > 1)
		if !room_for_partner && $PokemonTemp.battleRules["size"] &&
			 !["single", "1v1", "1v2", "1v3"].include?($PokemonTemp.battleRules["size"])
			room_for_partner = true
		end
		if $PokemonGlobal.partner && !$PokemonTemp.battleRules["noPartner"] && room_for_partner
			ally = NPCTrainer.new($PokemonGlobal.partner[1], $PokemonGlobal.partner[0])
			ally.id    = $PokemonGlobal.partner[2]
			ally.party = $PokemonGlobal.partner[3]
			playerTrainers.push(ally)
			playerParty = []
			$player.party.each { |pkmn| playerParty.push(pkmn) }
			playerPartyStarts.push(playerParty.length)
			ally.party.each { |pkmn| playerParty.push(pkmn) }
			setBattleRule("double") if !$PokemonTemp.battleRules["size"]
		end
		# Create the battle scene (the visual side of it)
		scene = pbNewBattleScene
		# Create the battle class (the mechanics side of it)
		battle = PokeBattle_Battle.new(scene,playerParty,foeParty,playerTrainers,foeTrainers)
		battle.party1starts = playerPartyStarts
		battle.party2starts = foePartyStarts
		battle.items        = foeItems
		battle.endSpeeches  = foeEndSpeeches
		# Set various other properties in the battle class
		pbPrepareBattle(battle)
		$PokemonTemp.clearBattleRules
		# End the trainer intro music
		Audio.me_stop
		# Perform the battle itself
		decision = 0
		pbBattleAnimation(pbGetTrainerBattleBGM(foeTrainers),(battle.singleBattle?) ? 1 : 3,foeTrainers) {
			pbSceneStandby {
				decision = battle.pbStartBattle
			}
			pbAfterBattle(decision,canLose)
		}
		Input.update
		# Save the result of the battle in a Game Variable (1 by default)
		#    0 - Undecided or aborted
		#    1 - Player won
		#    2 - Player lost
		#    3 - Player or wild Pokémon ran from battle, or player forfeited the match
		#    5 - Draw
		pbSet(outcomeVar,decision)
		return decision
	else
		return battle_worm_trainer_battle_core(*args)
	end
end