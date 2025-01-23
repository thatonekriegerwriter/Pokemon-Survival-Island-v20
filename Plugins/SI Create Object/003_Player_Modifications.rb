



class Game_Character
  def move_through2(direction)
    old_through = @through
    @through = true
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    @through = old_through
  end
  def fancy_moveto2(new_x, new_y, leader)
    if self.x - new_x == 1 && self.y == new_y
      move_fancy2(4)
    elsif self.x - new_x == -1 && self.y == new_y
      move_fancy2(6)
    elsif self.x == new_x && self.y - new_y == 1
      move_fancy2(8)
    elsif self.x == new_x && self.y - new_y == -1
      move_fancy2(2)
    elsif self.x - new_x == 2 && self.y == new_y
      jump_fancy2(4, leader)
    elsif self.x - new_x == -2 && self.y == new_y
      jump_fancy2(6, leader)
    elsif self.x == new_x && self.y - new_y == 2
      jump_fancy2(8, leader)
    elsif self.x == new_x && self.y - new_y == -2
      jump_fancy2(2, leader)
    elsif self.x != new_x || self.y != new_y
      moveto(new_x, new_y)
    end
  end
  def move_fancy2(direction)
    delta_x = (direction == 6) ? 1 : (direction == 4) ? -1 : 0
    delta_y = (direction == 2) ? 1 : (direction == 8) ? -1 : 0
    new_x = self.x + delta_x
    new_y = self.y + delta_y
    # Move if new position is the player's, or the new position is passable,
    # or self's current position is not passable
    if ($game_player.x == new_x && $game_player.y == new_y) ||
       location_passable2?(new_x, new_y, 10 - direction) ||
       !location_passable2?(self.x, self.y, direction)
      move_through2(direction)
    end
  end
    def jump_fancy2(direction, leader)
    delta_x = (direction == 6) ? 2 : (direction == 4) ? -2 : 0
    delta_y = (direction == 2) ? 2 : (direction == 8) ? -2 : 0
    half_delta_x = delta_x / 2
    half_delta_y = delta_y / 2
    if location_passable2?(self.x + half_delta_x, self.y + half_delta_y, 10 - direction)
      # Can walk over the middle tile normally; just take two steps
      move_fancy2(direction)
      move_fancy2(direction)
    elsif location_passable2?(self.x + delta_x, self.y + delta_y, 10 - direction)
      # Can't walk over the middle tile, but can walk over the end tile; jump over
      if location_passable2?(self.x, self.y, direction)
        if leader.jumping?
          @jump_speed_real = leader.jump_speed_real
        else
          # This is doubled because self has to jump 2 tiles in the time it
          # takes the leader to move one tile.
          @jump_speed_real = leader.move_speed_real * 2
        end
        jump(delta_x, delta_y)
      else
        # self's current tile isn't passable; just take two steps ignoring passability
        move_through2(direction)
        move_through2(direction)
      end
    end
  end

  def location_passable2?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for followe
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.each_value do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end


  def move_toward_player(target=$game_player)
      target = $game_map.events[target] if target.is_a?(Integer)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end


end





class Battle


  
   def pbGainEVsOne(idxParty, defeatedBattler)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
    evYield = defeatedBattler.pokemon.evYield
    # Num of effort points pkmn already has
    evTotal = 0
    GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
    # Modify EV yield based on pkmn's held item
    if !Battle::ItemEffects.triggerEVGainModifier(pkmn.item, pkmn, evYield)
      Battle::ItemEffects.triggerEVGainModifier(@initialItems[0][idxParty], pkmn, evYield)
    end
    # Double EV gain because of Pokérus
    if pkmn   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 1.1 }
    end
    if pkmn.happiness>=200   # Infected or cured
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.age.nil?
      pkmn.age=rand(50)+1
    end
    if pkmn.age>=1 && pkmn.age<=20
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>20 && pkmn.age<=40
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>40 && pkmn.sleep<=60
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>60 && pkmn.age<=80
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>80
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.pokerusStage >= 1   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 3 }
    end
    # Gain EVs for each stat in turn
    if pkmn.shadowPokemon? && pkmn.saved_ev && pkmn.level!=20
      pkmn.saved_ev.each_value { |e| evTotal += e }
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id] - pkmn.saved_ev[s.id])
        evGain = evGain*3
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.saved_ev[s.id] += evGain
        evTotal += evGain
      end
    else
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id])
        if pkmn.purifiedPokemon?
        evGain = evGain*1.5
        end
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.ev[s.id] += evGain
        evTotal += evGain
      end
    end



 end
  



  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining Exp from defeatedBattler
    growth_rate = pkmn.growth_rate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end
    return if pkmn.level == 20 && pkmn.shadowPokemon?
    isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
	level_cap = caughtmon.level_cap
	if level_cap.nil?
    level_cap = $PokemonSystem.level_caps == 0 ? Level_Cap::LEVEL_CAP[$game_system.level_cap] : Settings::MAXIMUM_LEVEL 
	end
	level_cap = Settings::MAXIMUM_LEVEL if $player.is_it_this_class?(:EXPERT,false)
	if !growth_rate.exp_values[level_cap]
    level_cap_gap = growth_rate.exp_values[level_cap] - pkmn.exp
	else
    level_cap_gap = growth_rate.exp_values[4] - pkmn.exp
	end
    # Main Exp calculation
    exp = 0
	
    a = level * defeatedBattler.pokemon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
    end

    return if exp <= 0
    # Pokémon gain more Exp from trainer battles
    exp = (exp * 1.5).floor if Settings::MORE_EXP_FROM_TRAINER_POKEMON && trainerBattle? && !pkmn.shadowPokemon?
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language))

    if isOutsider && !pkmn.shadowPokemon?
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language 
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    # Modify Exp gain based on pkmn's held item
    i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    if i < 0
      i = Battle::ItemEffects.triggerExpGainModifier(@initialItems[0][idxParty], pkmn, exp)
    end
    exp = i if i >= 0
    # Boost Exp gained with high affection
    if @internalBattle && pkmn.happiness >= 240 && !pkmn.mega?
      exp = exp * 6 / 5
      isOutsider = true   # To show the "boosted Exp" message
    end
    exp = exp/1.5 if pkmn.shadowPokemon?
    # Make sure Exp doesn't exceed the maximum
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    pkmn.stored_exp += exp if exp>=0
    expGained = expFinal - pkmn.exp

    return if expGained <= 0
    # "Exp gained" message
	if !pkmn.shadowPokemon?
    if showMessages
      if isOutsider
        pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!", pkmn.name, expGained))
      else
        pbDisplayPaused(_INTL("{1} got {2} Exp. Points!", pkmn.name, expGained))
      end
    end
	end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel < curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
                  pkmn.name, debugInfo)
    end
    # Give Exp
    $stats.total_exp_gained += expGained
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
	
	return if newLevel > level_cap
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp < expFinal) ? levelMaxExp : expFinal
      @scene.pbEXPBar(battler, levelMinExp, levelMaxExp, tempExp1, tempExp2)
      curLevel += 1
      if curLevel > newLevel
        # Gained all the Exp now, end the animation
        #pkmn.calc_stats
        battler&.pbUpdate(false)
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
    end



  end
  end

class Battle
  def pbGainExp
    # Play wild victory music if it's the end of the battle (has to be here)
    @scene.pbWildBattleSuccess if wildBattle? && pbAllFainted?(1) && !pbAllFainted?(0)
    return if !@internalBattle || !@expGain
    # Go through each battler in turn to find the Pokémon that participated in
    # battle against it, and award those Pokémon Exp/EVs
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
    p1 = pbParty(0)
    @battlers.each do |b|
      next unless b&.opposes?   # Can only gain Exp from fainted foes
      next if b.participants.length == 0
      next unless b.fainted? || b.captured
      # Count the number of participants
      numPartic = 0
      b.participants.each do |partic|
        next unless p1[partic]&.able? && pbIsOwner?(0, partic)
        numPartic += 1
      end
      # Find which Pokémon have an Exp Share
      expShare = []
      if !expAll
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE) && GameData::Item.try_get(@initialItems[0][i]) != :EXPSHARE
          expShare.push(i)
        end
      end
      # Calculate EV and Exp gains for the participants
      if numPartic > 0 || expShare.length > 0 || expAll
        # Gain EVs and Exp for participants
        eachInTeam(0, 0) do |pkmn, i|
          next if !pkmn.able?
          next unless b.participants.include?(i) || expShare.include?(i)
          pbGainEVsOne(i, b)
          pbGainExpOne(i, b, numPartic, expShare, expAll)
        end
        # Gain EVs and Exp for all other Pokémon because of Exp All
        if expAll
          showMessage = true
          eachInTeam(0, 0) do |pkmn, i|
            next if !pkmn.able?
            next if b.participants.include?(i)
            pbDisplayPaused(_INTL("Your other Pokémon also gained Exp. Points!")) if showMessage
            showMessage = false
            pbGainEVsOne(i, b)
            pbGainExpOne(i, b, numPartic, expShare, expAll, false)
            pbPlayerEXP(b.pokemon)
          end
        end
      end
      # Clear the participants array
      b.participants = []
    end
  end
end

  #ADD EVS
  def pokemonEXP(participants,caughtmon,pkmn)
    growth_rate = pkmn.growth_rate
      return if pkmn.egg?
    expAll = $player.has_exp_all || $bag.has?(:EXPALL)
      numPartic = 0
      participants.each do |partic|
        next unless partic.able?
        numPartic += 1
      end
	
      expShare = []
      if !expAll
        $player.party.each_with_index do |pkmn, i|
          next if !pkmn.able?
          next if !pkmn.hasItem?(:EXPSHARE)
          expShare.push(i)
        end
      end
	
	
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp >= growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end


    isPartic    = participants.include?(pkmn)
    hasExpShare = expShare.include?(pkmn)
    level = caughtmon.level
	level_cap = caughtmon.level_cap
	if level_cap.nil?
    level_cap = $PokemonSystem.level_caps == 0 ? Level_Cap::LEVEL_CAP[$game_system.level_cap] : Settings::MAXIMUM_LEVEL 
	end
	level_cap = Settings::MAXIMUM_LEVEL if $player.is_it_this_class?(:EXPERT,false)
	if !growth_rate.exp_values[level_cap]
    level_cap_gap = growth_rate.exp_values[level_cap] - pkmn.exp
	else
    level_cap_gap = growth_rate.exp_values[4] - pkmn.exp
	end
    # Main Exp calculation
    exp = 0
    a = level * caughtmon.base_exp
    if expShare.length > 0 && (isPartic || hasExpShare)
      if numPartic == 0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a / (2 * numPartic) if isPartic
        exp += a / (2 * expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a / 2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a / 2
	 else
      exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    end
    return if exp <= 0
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = ((2 * level) + 10.0) / (pkmn.level + level + 10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != $player.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != $player.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != $player.language
        exp = (exp * 1.7).floor
      else
        exp = (exp * 1.5).floor
      end
    end
    # Exp. Charm increases Exp gained
    exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
    # Modify Exp gain based on pkmn's held item
    i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    if i < 0
      i = Battle::ItemEffects.triggerExpGainModifier(pkmn.item, pkmn, exp)
    end
    exp = i if i >= 0
    # Boost Exp gained with high affection
    if pkmn.happiness >= 240 && !pkmn.mega?
      exp = exp * 6 / 5
      isOutsider = true   # To show the "boosted Exp" message
    end
    # Make sure Exp doesn't exceed the maximum
	
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    pkmn.stored_exp += exp if exp>=0
    expGained = expFinal - pkmn.exp
    return if expGained <= 0
    # "Exp gained" message
      if isOutsider
	     sideDisplay("\\ts[]" + (_INTL"#{pkmn.name} got a boosted #{expGained} Exp. Points!\\wtnp[10]"))
      else
        sideDisplay(_INTL("{1} got {2} Exp. Points!", pkmn.name, expGained))
      end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel < curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
                  pkmn.name, debugInfo)
    end
    # Give Exp
      
    $stats.total_exp_gained += expGained
	

 end  
  def pbPlayerEXP(caughtmon,pkmnless=[])
    return false
    caughtmon_level=caughtmon.level
    pkmn = $player
      growth_rate = GameData::GrowthRate.get(:Slow)
	  if pkmn.exp.nil?
	    pkmn.exp=0
	  end
      # Don't bother calculating if gainer is already at max Exp
      #return if pkmn.exp>=100
      exp=(caughtmon_level*caughtmon.base_exp)/2
      # Scale the gained Exp based on the gainer's level (or not)
      # Make sure Exp doesn't exceed the maximum
       exp /= 7
       exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
      expFinal = growth_rate.add_exp(pkmn.exp, exp)
      expGained = expFinal-pkmn.exp
      return if expGained<=0
      curLevel = pkmn.playerclasslevel
      newLevel = growth_rate.level_from_exp(expFinal)
      tempExp1 = pkmn.exp
      loop do   # For each level gained in turn...
        # EXP Bar animation
        levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
        tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
        pkmn.exp = tempExp2
        tempExp1 = tempExp2
        curLevel += 1
		pbSEPlay("Pkmn exp gain")
        if curLevel>newLevel
          # Gained all the Exp now, end the animation
          break
        end
    end



     pbMessage("\\ts[]" + (_INTL"#{pkmn.name} leveled up to #{newLevel}!\\wtnp[10]"))
	 
	 
      pkmn.playerclasslevel=newLevel
	  pkmnless.each do |pkmn2|
	    pokemonEVs(pkmn2, caughtmon)
	    pokemonEXP([pkmn2],caughtmon,pkmn2)
	  end
  end



  
   def pokemonEVs(pkmn, target)
    evYield = target.evYield
    # Num of effort points pkmn already has
    evTotal = 0
    GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
    # Modify EV yield based on pkmn's held item
    if !Battle::ItemEffects.triggerEVGainModifier(pkmn.item, pkmn, evYield)
      Battle::ItemEffects.triggerEVGainModifier(@initialItems[0][idxParty], pkmn, evYield)
    end
    # Double EV gain because of Pokérus
    if pkmn   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 1.1 }
    end
    if pkmn.happiness>=200   # Infected or cured
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.age.nil?
      pkmn.age=rand(50)+1
    end
    if pkmn.age>=1 && pkmn.age<=20
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>20 && pkmn.age<=40
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>40 && pkmn.sleep<=60
      evYield.each_key { |stat| evYield[stat] += 4 }
    end
    if pkmn.age>60 && pkmn.age<=80
      evYield.each_key { |stat| evYield[stat] += 2 }
    end
    if pkmn.age>80
      evYield.each_key { |stat| evYield[stat] += 1 }
    end
    if pkmn.pokerusStage >= 1   # Infected or cured
      evYield.each_key { |stat| evYield[stat] *= 3 }
    end
    # Gain EVs for each stat in turn
    if pkmn.shadowPokemon? && pkmn.saved_ev && pkmn.level!=20
      pkmn.saved_ev.each_value { |e| evTotal += e }
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id] - pkmn.saved_ev[s.id])
        evGain = evGain*3
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.saved_ev[s.id] += evGain
        evTotal += evGain
      end
    else
      GameData::Stat.each_main do |s|
        evGain = evYield[s.id].clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[s.id])
        if pkmn.purifiedPokemon?
        evGain = evGain*1.5
        end
        evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
        pkmn.ev[s.id] += evGain
        evTotal += evGain
      end
    end


    end
  




 
def pbMoveTowardEvent9(event,target)
  maxsize = [$game_map.width, $game_map.height].max
  return false if $game_temp.preventspawns==true
  return false if !pbEventCanReachPlayer?(event, target, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_target(target)
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
  pbMoveRoute2(event, [PBMoveRoute::Wait, (Graphics.frame_rate*(rand(4)+1))])
  return true
end

class Game_Character
  def move_toward_target(target)
    sx = @x + (@width / 2.0) - (target.x + (target.width / 2.0))
    sy = @y - (@height / 2.0) - (target.y - (target.height / 2.0))
    return if sx == 0 && sy == 0
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      (rand(2) == 0) ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      (sx > 0) ? move_left : move_right
      if !moving? && sy != 0
        (sy > 0) ? move_up : move_down
      end
    else
      (sy > 0) ? move_up : move_down
      if !moving? && sx != 0
        (sx > 0) ? move_left : move_right
      end
    end
  end
end

def didMoveTowardsPlayer?(event)
pbMoveTowardPlayer9(event)
return true
end


def pbMoveTowardPlayer9(event)
  maxsize = [$game_map.width, $game_map.height].max
  return false if $game_temp.preventspawns==true
  return if !pbEventCanReachPlayer?(event, $game_player, maxsize)
  loop do
    x = event.x
    y = event.y
    event.move_toward_player
    break if event.x == x && event.y == y
    while event.moving?
      Graphics.update
      Input.update
      pbUpdateSceneMap
    end
  end
end




# Set up various data related to the new map
EventHandlers.add(:on_enter_map, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon.empty?
	  $game_temp.following_ov_pokemon.keys.each do |key|
	         event_id = key
		     next if event_id.nil?
		     theevent = $game_temp.following_ov_pokemon[key][2]
			 next if theevent.nil?
			 puts "Hey this is running while map interpA" if $game_system.map_interpreter.running?
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap


      end

}
)

EventHandlers.add(:on_map_transfer, :recreate_follower_event,
  proc { |old_map_id|   # previous map ID, is 0 if no map ID
    next if old_map_id == 0 || old_map_id == $game_map.map_id
    next if $game_temp.following_ov_pokemon.empty?
	  $game_temp.following_ov_pokemon.keys.each do |key|
	         event_id = key
		     next if event_id.nil?
		     theevent = $game_temp.following_ov_pokemon[key][2]
			 next if theevent.nil?
			 puts "Hey this is running while map interpB" if $game_system.map_interpreter.running?
			 $game_map.recreateEvent2(theevent) if theevent.movement_type == :FOLLOW
			 pkmn.inworld=false if theevent.movement_type != :FOLLOW
			 theevent.removeThisEventfromMap


      end
}
)

def pbRemoveFollowerPokemon(id)
  $game_temp.following_ov_pokemon.delete(id)
end


