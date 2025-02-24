
#
# $PokemonSystem.difficulty=0 = Easy
# $PokemonSystem.difficulty=1 = Normal
# $PokemonSystem.difficulty=2 = Hard
# $PokemonSystem.difficulty=3 = Very Hard
#
#
#
def new_set_enemy_level(encounter)
  difficulty = $PokemonSystem.difficulty+1
  bosses = $game_variables[234].to_i
  level = calculate_level(encounter, difficulty, bosses)
  rates = get_new_rate(bosses)
  level = handle_game_map_levels(level, rates, bosses,encounter,difficulty)
  $game_variables[4951] = level if level > $game_variables[4951]
  return level
end

def pbPersonalLevelCap(pkmn)
 return 20 if pkmn.shadowPokemon?
 level_cap = $PokemonSystem.level_caps == 0 ? Level_Cap::LEVEL_CAP[$game_system.level_cap] : Settings::MAXIMUM_LEVEL
 level_cap = Settings::MAXIMUM_LEVEL if $player.is_it_this_class?(:EXPERT,false)
 obtainlevel = pkmn.obtain_level
 level = pkmn.level
 caplevel = level
 encounter = [pkmn,obtainlevel,level]
 puts pkmn.obtain_map
 obtainmap = $map_factory.maps[pkmn.obtain_map]
  difficulty = $PokemonSystem.difficulty+1
  bosses = $game_variables[234].to_i
  rates = get_new_rate(bosses)
   telling = 0
    loop do
  caplevel = handle_game_map_levels(level, rates, bosses,encounter,difficulty, obtainmap)
     if caplevel > level 
	    break
	 end 
	 if telling>5
	   caplevel+=level_cap
	   break
	 end
      telling+=1
    end
  return caplevel
end
def calculate_level(encounter, difficulty, bosses)
  return rand(encounter[2] * difficulty) - rand(encounter[3]) + pbBalancedLevel($player.party)
end

def calculate_reroll_level(encounter, difficulty)
  return rand(encounter[2] * difficulty) - rand(encounter[3]) + pbBalancedLevel($player.party)
end

def adjust_level(level, reroll_level, min_level, max_level)
  if level > max_level
    level = max_level - rand(3)
    level = reroll_level if reroll_level > level && reroll_level < max_level
  elsif level < min_level
    level = min_level + rand(11)
    level = reroll_level if reroll_level > min_level && reroll_level < max_level
  end
  if $PokemonGlobal.blackFluteUsed==true
        level = [level + rand(1..4), GameData::GrowthRate.max_level].min
  elsif $PokemonGlobal.whiteFluteUsed==true
        level = [level - rand(1..4), 1].max
  end 
  return level
end

def adjust_for_bosses(level, bosses, rates, encounter, difficulty)
  case bosses
  when 0
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 10, 10 + rates[0] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  when 1
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 10, 20 + rates[0] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  when 2
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 15, 35 + rates[1] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  when 3
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25, 40 + rates[1] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  when 4
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25, 45 + rates[2] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  when 5
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25, 50 + rates[2] + $PokemonGlobal.bossesRefightAmt["Temperate Ocean"].to_i)
  # Add additional cases for bosses 6-9 if needed
  end
  return level
end

def get_new_rate(bosses)
 return bosses*2,bosses*4,bosses*6
end

def handle_game_map_levels(level, rates, bosses,encounter, difficulty, map=nil)
  map = $game_map if map.nil?
	maps = [33,34,35,109,26,218,233]
  $PokemonGlobal.bossesRefightAmt == {} if $PokemonGlobal.bossesRefightAmt.nil?
  case map.name
  when "Temperate Coast", "Temperate Inland", "Temperate Shore", "Temperate Plains"
            #adjust_level(level, reroll_level,                           min_level,     max_level)
			
    amt = 20 + rates[2] + $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[76]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 10+amt0,amt)
	
	
	
	
	
  when "Temperate Highlands"
    amt = 30 + rates[2] + $PokemonGlobal.bossesRefightAmt["Temperate Highlands"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[83]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 15+amt0, amt)
	
	
	
	
	
	
	
	
	
  when "Mountain Interior", "Temperate Forest"
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[76]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 30 + rates[2] + $PokemonGlobal.bossesRefightAmt["Temperate Highlands"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25+amt0, amt)
	
	
	
	
	
	
  when "Ice Cave", "Frigid Highlands"
    amt = 35 + rates[1] + $PokemonGlobal.bossesRefightAmt["Frigid Highlands"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[79]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25+amt0, amt)
	
	
	
	
	
  when "Ice Temple"
    amt = 40 + rates[1] + $PokemonGlobal.bossesRefightAmt["Frigid Highlands"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[79]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 35+amt0, amt)
	
	
	
	
	
	
  when "Temperate Marsh"
    if  maps.include?(map.map_id)
    amt = 35 + rates[1] + $PokemonGlobal.bossesRefightAmt["Temperate Marsh"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[77]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 25+amt0, amt)
	else
    amt = 40 + rates[0] + $PokemonGlobal.bossesRefightAmt["Temperate Marsh"].to_i
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[77]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 35+amt0, amt)
	end
	
	
	
	
  when "Water Temple"
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[77]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 45 + rates[0] + $PokemonGlobal.bossesRefightAmt["Temperate Marsh"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 40+amt0, amt)
	
	
	
	
  when "S.S Glittering Wreck", "Abandoned Cabin", "Kitchen", "Captain's Quarters"
	amt0 = 0
	amt0 = +rand(7)+4 if $game_switches[81]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 50 + rates[0] + $PokemonGlobal.bossesRefightAmt["S.S Glittering"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 45+amt0, amt)
	
	
	
  when "Tropical Coast"
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[81]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 60 + rates[0] + $PokemonGlobal.bossesRefightAmt["Tropical Coast"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 50+amt0, amt)
	
	
	
	
  when "Tropical Highlands"
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[81]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 60 + rates[0] + $PokemonGlobal.bossesRefightAmt["Tropical Highlands"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 50+amt0, amt)
	
	
	
  when "Deep Caves"
	amt0 = 0
	amt0 += rand(7)+4 if $game_switches[81]=false
	amt0 += $PokemonGlobal.bossesRefightAmt["Temperate Coast"].to_i
    amt = 50 + rates[0] + $PokemonGlobal.bossesRefightAmt["Deep Caves"].to_i
    level = adjust_level(level, calculate_reroll_level(encounter, difficulty), 45+amt0, amt)
	
	
	
  when "Temperate Ocean"
    level = adjust_for_bosses(level, bosses, rates, encounter, difficulty)
  end
  return level
end














class PokemonEncounters
  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
	
	maps = [58,4,24,85]
    return if maps.include?($game_map.map_id) && $PokemonGlobal.blackFluteUsed == true
    return false if $game_system.encounter_disabled
    return false if !$player
    return false if $DEBUG && Input.press?(Input::CTRL)
    # Check if enc_type has a defined step chance/encounter table
    return false if !@step_chances[enc_type] || @step_chances[enc_type] == 0
    return false if !has_encounter_type?(enc_type)
    # Poké Radar encounters always happen, ignoring the minimum step period and
    # trigger probabilities
    return true if pbPokeRadarOnShakingGrass
    # Get base encounter chance and minimum steps grace period
    encounter_chance = @step_chances[enc_type].to_f
    min_steps_needed = (8 - (encounter_chance / 10)).clamp(0, 8).to_f
    # Apply modifiers to the encounter chance and the minimum steps amount
    #EDIT
    stainfluance = $player.playerstamina/$player.playermaxstamina
    encounter_chance *= 5
    min_steps_needed /= 3
    encounter_chance /= stainfluance
    min_steps_needed *= stainfluance
    if triggered_by_step
      encounter_chance += @chance_accumulator / 200
      encounter_chance *= 0.8 if $PokemonGlobal.bicycle
    end
      encounter_chance /= 2 if $PokemonGlobal.blackFluteUsed
      min_steps_needed *= 2 if $PokemonGlobal.blackFluteUsed
      encounter_chance *= 1.5 if $PokemonGlobal.whiteFluteUsed
      min_steps_needed /= 2 if $PokemonGlobal.whiteFluteUsed
      encounter_chance /= 3 if $player.playerclass.id == :RUNNER
    first_pkmn = $player.first_pokemon
    if first_pkmn
      case first_pkmn.item_id
      when :CLEANSETAG
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      when :PUREINCENSE
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      else   # Ignore ability effects if an item effect applies
        case first_pkmn.ability_id
        when :STENCH, :WHITESMOKE, :QUICKFEET
          encounter_chance /= 2
          min_steps_needed *= 2
        when :INFILTRATOR
          if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SNOWCLOAK
          if GameData::Weather.get($game_screen.weather_type).category == :Hail
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SANDVEIL
          if GameData::Weather.get($game_screen.weather_type).category == :Sandstorm
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SWARM
          encounter_chance *= 1.5
          min_steps_needed /= 2
        when :ILLUMINATE, :ARENATRAP, :NOGUARD
          encounter_chance *= 2
          min_steps_needed /= 2
        end
      end
    end
    # Wild encounters are much less likely to happen for the first few steps
    # after a previous wild encounter
    if triggered_by_step && @step_count > min_steps_needed
      return true if rand(100) <= encounter_chance * 5 / (@step_chances[enc_type] + (@chance_accumulator / 200))
    end
    # Decide whether the wild encounter should actually happen
    return true if rand(50) < encounter_chance
    # If encounter didn't happen, make the next step more likely to produce one
    if triggered_by_step
      @chance_accumulator += @step_chances[enc_type]
      @chance_accumulator = 0 if repel_active
    end
    return false
  end

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
   
    level =  new_set_enemy_level(encounter)
 
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
    if level < 1
     level = 1 
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
    if $DEBUG
      logMsg = "[AI] Move choices for #{user.pbThis(true)} (#{user.index}): "
      choices.each_with_index do |c, i|
        logMsg += "#{user.moves[c[0]].name}=#{c[1]}"
        logMsg += " (target #{c[2]})" if c[2] >= 0
        logMsg += ", " if i < choices.length - 1
      end
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

class Battle::Peer
  def pbStorePokemon(player, pkmn)
    if !player.party_full?
      player.party[player.party.length] = pkmn
      return -1
    end
    if Settings::HEAL_STORED_POKEMON
      old_ready_evo = pkmn.ready_to_evolve
      pkmn.heal
      pkmn.ready_to_evolve = old_ready_evo
    end
	pkmn.calc_stats
    oldCurBox = pbCurrentBox
    storedBox = $PokemonStorage.pbStoreCaught(pkmn)
    if storedBox < 0
      # NOTE: Poké Balls can't be used if storage is full, so you shouldn't ever
      #       see this message.
      pbDisplayPaused(_INTL("Can't catch any more..."))
      return oldCurBox
    end
    return storedBox
  end
end


EventHandlers.add(:on_wild_pokemon_created, :level_depends_on_party3,
  proc { |genwildpoke|
  genwildpoke.age = (rand(41)+3)
  genwildpoke.lifespan = 100
  genwildpoke.water = (rand(100)+50)
  genwildpoke.food = (rand(100)+50)
  genwildpoke.water = 100 if genwildpoke.water>100
  genwildpoke.food = 100 if genwildpoke.food>100
  genwildpoke.loyalty = 75
  if genwildpoke.age <= 10
    genwildpoke.ev[:DEFENSE] = rand(40)+10
    genwildpoke.ev[:SPECIAL_DEFENSE] = rand(40)+10
    genwildpoke.ev[:ATTACK] = rand(40)+10
    genwildpoke.ev[:SPECIAL_ATTACK] = rand(40)+10
    genwildpoke.ev[:SPEED] = rand(40)+10
    genwildpoke.ev[:HP] = rand(40)+10
  elsif genwildpoke.age <= 20 && genwildpoke.age > 10
    genwildpoke.ev[:DEFENSE] = rand(80)+10
    genwildpoke.ev[:SPECIAL_DEFENSE] = rand(80)+10
    genwildpoke.ev[:ATTACK] = rand(80)+10
    genwildpoke.ev[:SPECIAL_ATTACK] = rand(80)+10
    genwildpoke.ev[:SPEED] = rand(80)+10
    genwildpoke.ev[:HP] = rand(80)+10
  elsif genwildpoke.age <= 30 && genwildpoke.age > 20
    genwildpoke.ev[:DEFENSE] = rand(120)+10
    genwildpoke.ev[:SPECIAL_DEFENSE] = rand(120)+10
    genwildpoke.ev[:ATTACK] = rand(120)+10
    genwildpoke.ev[:SPECIAL_ATTACK] = rand(120)+10
    genwildpoke.ev[:SPEED] = rand(120)+10
    genwildpoke.ev[:HP] = rand(120)+10
  elsif genwildpoke.age <= 40 && genwildpoke.age > 30
    genwildpoke.ev[:DEFENSE] = rand(150)+10
    genwildpoke.ev[:SPECIAL_DEFENSE] = rand(150)+10
    genwildpoke.ev[:ATTACK] = rand(150)+10
    genwildpoke.ev[:SPECIAL_ATTACK] = rand(150)+10
    genwildpoke.ev[:SPEED] = rand(150)+10
    genwildpoke.ev[:HP] = rand(150)+10
  elsif genwildpoke.age > 40
    genwildpoke.ev[:DEFENSE] = rand(200)+10
    genwildpoke.ev[:SPECIAL_DEFENSE] = rand(200)+10
    genwildpoke.ev[:ATTACK] = rand(200)+10
    genwildpoke.ev[:SPECIAL_ATTACK] = rand(200)+10
    genwildpoke.ev[:SPEED] = rand(200)+10
    genwildpoke.ev[:HP] = rand(200)+10
  end
#  case $PokemonSystem.difficulty
 #  when 1
 #   genwildpoke.totalhp*=1.25
#	genwildpoke.hp=genwildpoke.totalhp
 #  when 2
 #   genwildpoke.totalhp*=1.50
#	genwildpoke.hp=genwildpoke.totalhp
 #  when 3
#    genwildpoke.totalhp*=1.50
#	genwildpoke.hp=genwildpoke.totalhp
#  end
  }
)


MenuHandlers.add(:options_menu, :difficulty, {
  "name"        => _INTL("Difficulty"),
  "parent"      => :gameplay_menu,
  "order"       => 35,
  "type"        => EnumOption,
  "condition"   => proc { next $player && false },
  "parameters"  => [_INTL("Easy"), _INTL("Normal"), _INTL("Hard"), _INTL("Very Hard")],
  "description" => _INTL("Choose the Difficulty of the Game."),
  "get_proc"    => proc { next $PokemonSystem.difficulty },
  "set_proc"    => proc { |value, scene| 
  $PokemonSystem.difficulty = value}
})
