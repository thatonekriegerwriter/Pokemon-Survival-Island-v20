class PokemonEncounters
  def choose_wild_pokemon(enc_type, chance_rolls = 1)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    enc_list = @encounter_tables[enc_type]
    return nil if !enc_list || enc_list.length == 0
    # Static/Magnet Pull prefer wild encounters of certain types, if possible.
    # If they activate, they remove all Pokémon from the encounter table that do
    # not have the type they favor. If none have that type, nothing is changed.
    first_pkmn = $player.first_pokemon
    if first_pkmn
      favored_type = nil
      case first_pkmn.ability_id
      when :FLASHFIRE
        favored_type = :FIRE if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                GameData::Type.exists?(:FIRE) && rand(100) < 50
      when :HARVEST
        favored_type = :GRASS if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:GRASS) && rand(100) < 50
      when :LIGHTNINGROD
        favored_type = :ELECTRIC if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                    GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :MAGNETPULL
        favored_type = :STEEL if GameData::Type.exists?(:STEEL) && rand(100) < 50
      when :STATIC
        favored_type = :ELECTRIC if GameData::Type.exists?(:ELECTRIC) && rand(100) < 50
      when :STORMDRAIN
        favored_type = :WATER if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS &&
                                 GameData::Type.exists?(:WATER) && rand(100) < 50
      end
      if favored_type
        new_enc_list = []
        enc_list.each do |enc|
          species_data = GameData::Species.get(enc[1])
          new_enc_list.push(enc) if species_data.types.include?(favored_type)
        end
        enc_list = new_enc_list if new_enc_list.length > 0
      end
    end
    enc_list.sort! { |a, b| b[0] <=> a[0] }   # Highest probability first
    # Calculate the total probability value
    chance_total = 0
    enc_list.each { |a| chance_total += a[0] }
    # Choose a random entry in the encounter table based on entry probabilities
    rnd = 0
    chance_rolls.times do
      r = rand(chance_total)
      rnd = r if r > rnd   # Prefer rarer entries if rolling repeatedly
    end
    encounter = nil
    enc_list.each do |enc|
      rnd -= enc[0]
      next if rnd >= 0
      encounter = enc
      break
    end
    # Get the chosen species and level
  if $game_switches[140]==true
    old_level = rand(encounter[2]..encounter[3])
    difficulty=$PokemonSystem.difficulty+1
	bosses = $game_variables[234].to_i
	lowrate= bosses*2
	middlerate= bosses*4
	highrate= bosses*6
    level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
	maps = [33,34,35,109,26,218,233]
	if level > $game_variables[4951]
	$game_variables[4951]=level 
	end
    if level < 5
     level = 5 
    end
    if level > 100
     level = 100 
    end
	if $game_map.name == "Temperate Coast" || $game_map.name == "Temperate Inland" || $game_map.name == "Temperate Shore" || $game_map.name == "Temperate Plains"
     if level > (20+highrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (10+rand(11)) 
	  if reroll_level > level && reroll_level < (30+highrate)
	   level = reroll_level
	  end 
	 end
    elsif $game_map.name == "Temperate Highlands"
     if level > (30+highrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level > level && reroll_level < (30+highrate)
	   level = reroll_level
	  end 
	 end
	 if level < 15
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level < level && reroll_level > 15
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Mountain Interior" || $game_map.name == "Temperate Forest"
     if level > (30+highrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level > level && reroll_level < (30+highrate)
	   level = reroll_level
	  end 
	 end
	 if level < 25
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level < level && reroll_level > 25
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Ice Cave" || $game_map.name == "Frigid Highlands"
     if level > (35+middlerate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level > level && reroll_level < (35+middlerate)
	   level = reroll_level
	  end 
	 end
	 if level < 25
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level < level && reroll_level > 25
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Ice Temple"
     if level > (40+middlerate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < (40+middlerate)
	   level = reroll_level
	  end 
	 end
	 if level < 35
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 35
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Temperate Marsh" && maps.include?($game_map.map_id)
     if level > (35+middlerate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level > level && reroll_level < (35+middlerate)
	   level = reroll_level
	  end 
	 end
	 if level < 25
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level < level && reroll_level > 25
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Temperate Marsh" && !maps.include?($game_map.map_id)
     if level > (40+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < (40+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 35
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 35
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Water Temple"
     if level > (45+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < (45+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 40
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 40
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "S.S Glittering Wreck" || $game_map.name == "Abandoned Cabin" || $game_map.name == "Kitchen" || $game_map.name == "Captain's Quarters"
     if level > (50+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < (50+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 45
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 45
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Tropical Coast" #Humid Zone
     if level > (45+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < (45+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 40
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 40
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Tropical Highlands" #Northern Area
     if level > (60+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (45+rand(26)) 
	  if reroll_level > level && reroll_level < (60+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 50
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (45+rand(26)) 
	  if reroll_level < level && reroll_level > 50
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Temperate Skies" || $game_map.name == "Shore Skies"|| $game_map.name == "Ocean Skies"|| $game_map.name == "Mountain Skies"|| $game_map.name == "Mountain Skies"
     if level > (60+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (45+rand(26)) 
	  if reroll_level > level && reroll_level < (60+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 50
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (45+rand(26)) 
	  if reroll_level < level && reroll_level > 50
	   level = reroll_level
	  end 
	 end 
    elsif $game_map.name == "Temperate Ocean" || $game_map.name == "Southern Ocean"
     if bosses = 0 
	  if level > 10
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (10+rand(11)) 
	 if reroll_level > level && reroll_level < 10
	   level = reroll_level
	 end 
	 end
     elsif bosses == 1 #TEMPERATE
	  if level > 20 
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (10+rand(11)) 
	 if reroll_level > level && reroll_level < 20
	   level = reroll_level
	 end 
	 end
	 elsif bosses == 2 #MOUNTAIN
     if level > 35
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level > level && reroll_level < 35
	   level = reroll_level
	  end 
	 end
	 if level < 25
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (15+rand(16)) 
	  if reroll_level < level && reroll_level > 25
	   level = reroll_level
	  end 
	 end
	 elsif bosses == 3 #ICE
	 if level > 40
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < 20
	   level = reroll_level
	  end 
	 end
	 if level < 35
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 15
	   level = reroll_level
	  end 
	 end 
	 elsif bosses == 4 #WATER
     if level > 45
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < 20
	   level = reroll_level
	  end 
	 end
	 if level < 40
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 15
	   level = reroll_level
	  end 
	 end 
	 elsif bosses == 5 #SPOOKY
	   if level > 50
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level > level && reroll_level < 20
	   level = reroll_level
	  end 
	 end
	 if level < 45
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (25+rand(16)) 
	  if reroll_level < level && reroll_level > 15
	   level = reroll_level
	  end 
	 end 

	 elsif bosses == 6
	 elsif bosses == 7
	 elsif bosses == 8
	 elsif bosses == 9
	 else
	 end
    elsif $game_map.name == "Deep Caves"
     if level > (50+lowrate)
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (35+rand(16)) 
	  if reroll_level > level && reroll_level < (50+lowrate)
	   level = reroll_level
	  end 
	 end
	 if level < 45
	  reroll_level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
      level = (35+rand(16)) 
	  if reroll_level < level && reroll_level > 45
	   level = reroll_level
	  end 
	 end 
    else 
    level= rand(encounter[2]*difficulty)-rand(encounter[3])+pbBalancedLevel($player.party)
	end
  else
    level = rand(encounter[2]..encounter[3])
  end
    # Some abilities alter the level of the wild Pokémon
    if first_pkmn
      case first_pkmn.ability_id
      when :HUSTLE, :PRESSURE, :VITALSPIRIT
        level = [level + rand(1..4), GameData::GrowthRate.max_level].max
      end
    end
    # Black Flute and White Flute alter the level of the wild Pokémon
    if Settings::FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS
      if $PokemonMap.blackFluteUsed
        level = [level + rand(1..4), GameData::GrowthRate.max_level].min
      elsif $PokemonMap.whiteFluteUsed
        level = [level - rand(1..4), 1].max
      end
    end
    # Return [species, level]
    return [encounter[1], level]
  end



end

class Battle::AI


  def pbChooseMoves(idxBattler)
    user        = @battle.battlers[idxBattler]
    wildBattler = user.wild?
    skill       = 0
    if !wildBattler
      skill     = @battle.pbGetOwnerFromBattlerIndex(user.index).skill_level || 0
    else
      skill=($PokemonSystem.difficulty+1)*$PokemonSystem.difficultymodifier										   
    end
    # Get scores and targets for each move
    # NOTE: A move is only added to the choices array if it has a non-zero
    #       score.
    choices     = []
    user.eachMoveWithIndex do |_m, i|
      next if !@battle.pbCanChooseMove?(idxBattler, i, false)
      if wildBattler
        #pbRegisterMoveWild(user, i, choices)
        pbRegisterMoveTrainer(user,i,choices,skill)										   
      else
        pbRegisterMoveTrainer(user, i, choices, skill)
      end
    end
    # Figure out useful information about the choices
    totalScore = 0
    maxScore   = 0
    choices.each do |c|
      totalScore += c[1]
      maxScore = c[1] if maxScore < c[1]
    end
    # Log the available choices
    if $INTERNAL
      logMsg = "[AI] Move choices for #{user.pbThis(true)} (#{user.index}): "
      choices.each_with_index do |c, i|
        logMsg += "#{user.moves[c[0]].name}=#{c[1]}"
        logMsg += " (target #{c[2]})" if c[2] >= 0
        logMsg += ", " if i < choices.length - 1
      end
      PBDebug.log(logMsg)
    end
    # Find any preferred moves and just choose from them
    if skill >= PBTrainerAI.highSkill && maxScore > 100
      stDev = pbStdDev(choices)
      if stDev >= 40 && pbAIRandom(100) < 90
        preferredMoves = []
        choices.each do |c|
          next if c[1] < 200 && c[1] < maxScore * 0.8
          preferredMoves.push(c)
          preferredMoves.push(c) if c[1] == maxScore   # Doubly prefer the best move
        end
        if preferredMoves.length > 0
          m = preferredMoves[pbAIRandom(preferredMoves.length)]
          PBDebug.log("[AI] #{user.pbThis} (#{user.index}) prefers #{user.moves[m[0]].name}")
          @battle.pbRegisterMove(idxBattler, m[0], false)
          @battle.pbRegisterTarget(idxBattler, m[2]) if m[2] >= 0
          return
        end
      end
    end
    # Decide whether all choices are bad, and if so, try switching instead
    if skill >= PBTrainerAI.highSkill
      badMoves = false
      if ((maxScore <= 20 && user.turnCount > 2) ||
         (maxScore <= 40 && user.turnCount > 5)) && pbAIRandom(100) < 80
        badMoves = true
      end
      if !badMoves && totalScore < 100 && user.turnCount > 1
        badMoves = true
        choices.each do |c|
          next if !user.moves[c[0]].damagingMove?
          badMoves = false
          break
        end
        badMoves = false if badMoves && pbAIRandom(100) < 10
      end
      if badMoves && pbEnemyShouldWithdrawEx?(idxBattler, true)
        if $INTERNAL
          PBDebug.log("[AI] #{user.pbThis} (#{user.index}) will switch due to terrible moves")
        end
        return
      end
    end
    # If there are no calculated choices, pick one at random
    if choices.length == 0
      PBDebug.log("[AI] #{user.pbThis} (#{user.index}) doesn't want to use any moves; picking one at random")
      user.eachMoveWithIndex do |_m, i|
        next if !@battle.pbCanChooseMove?(idxBattler, i, false)
        choices.push([i, 100, -1])   # Move index, score, target
      end
      if choices.length == 0   # No moves are physically possible to use; use Struggle
        @battle.pbAutoChooseMove(user.index)
      end
    end
    # Randomly choose a move from the choices and register it
    randNum = pbAIRandom(totalScore)
    choices.each do |c|
      randNum -= c[1]
      next if randNum >= 0
      @battle.pbRegisterMove(idxBattler, c[0], false)
      @battle.pbRegisterTarget(idxBattler, c[2]) if c[2] >= 0
      break
    end
    # Log the result
    if @battle.choices[idxBattler][2]
      PBDebug.log("[AI] #{user.pbThis} (#{user.index}) will use #{@battle.choices[idxBattler][2].name}")
    end
  end




end