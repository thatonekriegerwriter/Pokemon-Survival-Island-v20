class Battle
  #=============================================================================
  # Running from battle
  #=============================================================================
  def pbCanRun?(idxBattler)
    return false if trainerBattle?
    battler = @battlers[idxBattler]
    return false if !@canRun && !battler.opposes?
    #EDIT
    return false if $player.playerstamina<15
    return true if battler.pbHasType?(:GHOST) && Settings::MORE_TYPE_EFFECTS
    return true if battler.abilityActive? &&
                   Battle::AbilityEffects.triggerCertainEscapeFromBattle(battler.ability, battler)
    return true if battler.itemActive? &&
                   Battle::ItemEffects.triggerCertainEscapeFromBattle(battler.item, battler)
    return false if battler.trappedInBattle?
    allOtherSideBattlers(idxBattler).each do |b|
      return false if b.abilityActive? &&
                      Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
      return false if b.itemActive? &&
                      Battle::ItemEffects.triggerTrappingByTarget(b.item, battler, b, self)
    end
    return true
  end

  # Return values:
  # -1: Failed fleeing
  #  0: Wasn't possible to attempt fleeing, continue choosing action for the round
  #  1: Succeeded at fleeing, battle will end
  # duringBattle is true for replacing a fainted Pokémon during the End Of Round
  # phase, and false for choosing the Run command.
  def pbRun(idxBattler, duringBattle = false)
    battler = @battlers[idxBattler]
    if battler.opposes?
      return 0 if trainerBattle?
      @choices[idxBattler][0] = :Run
      @choices[idxBattler][1] = 0
      @choices[idxBattler][2] = nil
      return -1
    end
    # Fleeing from trainer battles
    if trainerBattle?
      if $DEBUG && Input.press?(Input::CTRL)
        if pbDisplayConfirm(_INTL("Treat this battle as a win?"))
          @decision = 1
          return 1
        elsif pbDisplayConfirm(_INTL("Treat this battle as a loss?"))
          @decision = 2
          return 1
        end
      elsif @internalBattle
        pbDisplayPaused(_INTL("No! There's no running from a Trainer battle!"))
      elsif pbDisplayConfirm(_INTL("Would you like to forfeit the match and quit now?"))
        pbSEPlay("Battle flee")
        pbDisplay(_INTL("{1} forfeited the match!", self.pbPlayer.name))
        @decision = 3
        return 1
      end
      return 0
    end
    # Fleeing from wild battles
    if $DEBUG && Input.press?(Input::CTRL)
      pbSEPlay("Battle flee")
      pbDisplayPaused(_INTL("You got away safely!"))
      @decision = 3
      return 1
    end
    if !@canRun
      pbDisplayPaused(_INTL("You can't escape!"))
      return 0
    end
    if !duringBattle
      #EDIT
      if battler.pbHasType?(:GHOST) && Settings::MORE_TYPE_EFFECTS && 1==2
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("You got away safely!"))
        @decision = 3
        return 1
      end
      # Abilities that guarantee escape
      if battler.abilityActive? &&
         Battle::AbilityEffects.triggerCertainEscapeFromBattle(battler.ability, battler)
        pbShowAbilitySplash(battler, true)
        pbHideAbilitySplash(battler)
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("You got away safely!"))
        @decision = 3
        return 1
      end
      # Held items that guarantee escape
      if battler.itemActive? &&
         Battle::ItemEffects.triggerCertainEscapeFromBattle(battler.item, battler)
        pbSEPlay("Battle flee")
        pbDisplayPaused(_INTL("{1} fled using its {2}!", battler.pbThis, battler.itemName))
        @decision = 3
        return 1
      end
      # Other certain trapping effects
      if battler.trappedInBattle?
        pbDisplayPaused(_INTL("You can't escape!"))
        return 0
      end
      # Trapping abilities/items
      allOtherSideBattlers(idxBattler).each do |b|
        next if !b.abilityActive?
        if Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!", b.pbThis, b.abilityName))
          return 0
        end
      end
      allOtherSideBattlers(idxBattler).each do |b|
        next if !b.itemActive?
        if Battle::ItemEffects.triggerTrappingByTarget(b.item, battler, b, self)
          pbDisplayPaused(_INTL("{1} prevents escape with {2}!", b.pbThis, b.itemName))
          return 0
        end
      end
    end
    # Fleeing calculation
    # Get the speeds of the Pokémon fleeing and the fastest opponent
    # NOTE: Not pbSpeed, because using unmodified Speed.
    #EDIT
    @runCommand += 1 if !duringBattle && rand(100)<25  # Make it easier to flee next time
    runInjury=rand(100)
    injury = rand(25)+1
    playercrit = rand(24)+1
    $player.playerstamina -= 5 if $player.playerstamina > 0
    if $player.playerstamina < 0
      $player.playerstamina = 0
    end
    speedPlayer = @battlers[idxBattler].speed
    speedEnemy = 1
    allOtherSideBattlers(idxBattler).each do |b|
      speed = b.speed
      speedEnemy = speed if speedEnemy < speed
    end
    # Compare speeds and perform fleeing calculation
      rate = (speedPlayer * 128) / speedEnemy
      rate += @runCommand * 5
      if @battlers[idxBattler].loyalty <=50
        pbDisplayPaused(_INTL("{1} tried to run away, but {2} wouldn't listen!",self.pbPlayer.name,@battlers[idxBattler]))
        return -1
      end
      if runInjury > 80 && $player.playerstamina<50
        if playercrit == 1
          injury = injury*2
        end
        pbDisplayPaused(_INTL("{1} is too out of breath, they can't run away!",self.pbPlayer.name))
        if rand(2) == 1
        pbDisplayPaused(_INTL("{1} got hit with an attack! It did {2} damage!",self.pbPlayer.name,injury))
        end
        @runCommand -= 2 if !duringBattle
        $player.playerhealth -= injury
		pbSEPlay("normaldamage")
       return -1
      end
    if @battleAI.pbAIRandom(256) < rate && $player.playerstamina != 0
      pbSEPlay("Battle flee")
      if runInjury > 70
        if playercrit == 1
          injury = injury*2
        end
        pbDisplayPaused(_INTL("While {1} was running away, they got nicked by an attack! It did {2} damage!",self.pbPlayer.name,injury))
        $player.playerhealth -= injury
		pbSEPlay("normaldamage")
        @decision = 3
      return 1
      else
      pbDisplayPaused(_INTL("You got away safely!"))
      @decision = 3
      return 1
      end
    end
    pbDisplayPaused(_INTL("You couldn't get away!"))
    return -1
  end
end


class Battle::Battler

  def canConsumeArgBerry?(check_gluttony = true)
    return false if !canConsumeBerry?
    return true if !battler.able
    return false
  end


 def pbObedienceCheck?(choice)
    return true if usingMultiTurnAttack?
    return true if choice[0]!=:UseMove
    return true if !@battle.internalBattle
    return true if !@battle.pbOwnedByPlayer?(@index)
    disobedient = false
    # Pokémon may be disobedient; calculate if it is
    badgeLevel = 10 * (@battle.pbPlayer.badge_count + 1)
    r = @battle.pbRandom(256)
    badgeLevel = GameData::GrowthRate.max_level if @battle.pbPlayer.badge_count >= 8
    if @pokemon.foreign?(@battle.pbPlayer) && @level>badgeLevel
	
      a = ((@level+badgeLevel)*@battle.pbRandom(256)/256).floor
      disobedient |= (a>=badgeLevel)
	  
    end
#EDIT
    return pbDisobey(choice, badgeLevel) if PbCalculate_disobedience_chance(@pokemon.loyalty,@pokemon.happiness) && rand(100)<= 25
#END EDIT
    disobedient |= !pbHyperModeObedience(choice[2])
    return true if !disobedient
    # Pokémon is disobedient; make it do something else
#    return pbDisobey(choice,badgeLevel)
  end

  def pbDisobey(choice,badgeLevel)
    move = choice[2]
    PBDebug.log("[Disobedience] #{pbThis} disobeyed")
    @effects[PBEffects::Rage] = false
    # Do nothing if using Snore/Sleep Talk
    if @status == :SLEEP && move.usableWhenAsleep?
      @battle.pbDisplay(_INTL("{1} ignored orders and kept sleeping!",pbThis))
      return false
    end
    c = @level-badgeLevel
    r = @battle.pbRandom(90)
    # Fall asleep
    if r <= 10  && pbCanSleep?(self,false)
      pbSleepSelf(_INTL("{1} began to nap!",pbThis))
      return false
    end
    # Hurt self in confusion
    if r <= 10 && @status != :SLEEP
      pbConfusionDamage(_INTL("{1} won't obey! It hurt itself in its confusion!",pbThis))
      return false
    end
    #EDIT
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness <= 149
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around and attacked you for {2} damage!",pbThis, injury))
      $player.playerhealth -= injury
		pbSEPlay("normaldamage")
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && @pokemon.happiness >= 199
      @battle.pbDisplay(_INTL("{1} wants to play!",pbThis))
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness <= 50
      injury = rand(10)+2
      @battle.pbDisplay(_INTL("{1} turned around rushed you down, hurting you for {2} damage!",pbThis, injury))
      $player.playerhealth -= injury
		pbSEPlay("normaldamage")
      return false 
    end
    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200
      @battle.pbDisplay(_INTL("{1} wants you to praise it before it does anything!",pbThis))
      return false 
    end
    # Use another move
    if (r <= 40 && r >= 30 && @status != :SLEEP) || (r <= 40 && r >= 30 && @status != :SLEEP  && @pokemon.happiness >= 199)
      @battle.pbDisplay(_INTL("{1} ignored orders!",pbThis))
      return false if !@battle.pbCanShowFightMenu?(@index)
      otherMoves = []
      eachMoveWithIndex do |_m,i|
        next if i==choice[1]
        otherMoves.push(i) if @battle.pbCanChooseMove?(@index,i,false)
      end
      return false if otherMoves.length==0   # No other move to use; do nothing
      newChoice = otherMoves[@battle.pbRandom(otherMoves.length)]
      choice[1] = newChoice
      choice[2] = @moves[newChoice]
      choice[3] = -1
      return true
    end
    # Show refusal message and do nothing
    case @battle.pbRandom(4)
    when 0 then @battle.pbDisplay(_INTL("{1} won't obey!",pbThis))
    when 1 then @battle.pbDisplay(_INTL("{1} turned away!",pbThis))
    when 2 then @battle.pbDisplay(_INTL("{1} is loafing around!",pbThis))
    when 3 then @battle.pbDisplay(_INTL("{1} pretended not to notice!",pbThis))
    end
    return false
  end

def PbCalculate_disobedience_chance(loyalty,happiness)
 amt = 0
  case loyalty
  when 0..50
    amt = 100
  when 50..75
    amt = 80
  when 76..149
    amt = 60
  when 150..224
    amt = 30
  when 225..254
    amt = 10
  when 255
    amt = 0 # No disobedience at maximum loyalty
  else
    amt = 0 # Default to no chance of disobedience if conditions are not met
  end
  amt-= (happiness/20).floor
  amt = 0 if amt<0
end

  end
  
  
def check_obedience(pkmn,directing=true)
  return true if pkmn == @opponent
  return disobeying(pkmn,directing) if calculate_disobedience_chance(pkmn.loyalty,pkmn.happiness) && rand(100)<= 25

end  
  
def disobeying(pkmn,directing)
   chance = rand(90)
  if pkmn.status == :SLEEP
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} ignored you and continued sleeping.\\wtnp[10]"))
      return false
  end
    if r <= 10  && pkmn.status==:NONE
	  pkmn.status=:SLEEP
	  pbMessage("\\ts[]" + (_INTL"#{pkmn.name} began to nap!\\wtnp[10]"))
      return false
    end
     if r <= 10 && @status != :SLEEP && directing==false
      pbMessage("\\ts[]" + ("#{pkmn.name} won't obey! It hurt itself in its confusion!\\wtnp[10]"))
	  pkmn.hp-=rand(25)+5
      return false
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && pkmn.loyalty <= 50 && directing==false
      injury = rand(10)+2
      pbMessage("\\ts[]" + ("#{pkmn.name} turned around and attacked you for #{injury} damage!\\wtnp[10]"))
      $player.playerhealth -= injury
		pbSEPlay("normaldamage")
      return false 
    end

    if r <= 30 && r >= 20 && @status != :SLEEP && @pokemon.happiness >= 200 && directing==false
      pbMessage("\\ts[]" + ("#{pkmn.name} wants you to praise it before it does anything!\\wtnp[10]"))
      return false 
    end
    if r <= 20 && r >= 10 && @status != :SLEEP && pkmn.happiness >= 199 && directing==false
      pbMessage("\\ts[]" + ("#{pkmn.name} wants to play!\\wtnp[10]"))
      return false 
    end




    case rand(4)
    when 0 then pbMessage("\\ts[]" + ("#{pkmn.name} won't obey!\\wtnp[10]"))
    when 1 then pbMessage("\\ts[]" + ("#{pkmn.name} turned away!\\wtnp[10]"))
    when 2 then pbMessage("\\ts[]" + ("#{pkmn.name} is loafing around!\\wtnp[10]"))
    when 3 then pbMessage("\\ts[]" + ("#{pkmn.name} pretended not to notice!\\wtnp[10]"))
    end
	return false
end  

def calculate_disobedience_chance(loyalty,happiness)
 amt = 0
  case loyalty
  when 0..50
    amt = 100
  when 50..75
    amt = 80
  when 76..149
    amt = 60
  when 150..224
    amt = 30
  when 225..254
    amt = 10
  when 255
    amt = 0 # No disobedience at maximum loyalty
  else
    amt = 0 # Default to no chance of disobedience if conditions are not met
  end
  amt-= (happiness/20).floor
  amt = 0 if amt<0
end
  
  
class PokemonEncounters
 # Returns whether a wild encounter should happen, based on its encounter
  # chance. Called when taking a step and by Rock Smash.
  
  def choose_wild_pokemon(enc_type, chance_rolls = 1)
    puts "hi there"
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



  
  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
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
      encounter_chance /= 2 if $PokemonMap.blackFluteUsed
      min_steps_needed *= 2 if $PokemonMap.blackFluteUsed
      encounter_chance *= 1.5 if $PokemonMap.whiteFluteUsed
      min_steps_needed /= 2 if $PokemonMap.whiteFluteUsed
      encounter_chance /= 3 if $player.playerclass == "Runner"
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

  # Returns whether an encounter with the given Pokémon should be allowed after
  # taking into account Repels and ability effects.
  def allow_encounter?(enc_data, repel_active = false)
    return false if !enc_data
    return true if pbPokeRadarOnShakingGrass
    # Repel
    if repel_active
      first_pkmn = (Settings::REPEL_COUNTS_FAINTED_POKEMON) ? $player.first_pokemon : $player.first_able_pokemon
      if first_pkmn && enc_data[1] < first_pkmn.level
        @chance_accumulator = 0
        return false
      end
    end
    # Some abilities make wild encounters less likely if the wild Pokémon is
    # sufficiently weaker than the Pokémon with the ability
    first_pkmn = $player.first_pokemon
    if first_pkmn
      case first_pkmn.ability_id
      when :INTIMIDATE, :KEENEYE
        return false if enc_data[1] <= first_pkmn.level - 5 && rand(100) < 50
      end
    end
    return true
  end

  # Returns whether a wild encounter should be turned into a double wild
  # encounter.
  def have_double_wild_battle?
    return false if $game_temp.force_single_battle
    return false if pbInSafari?
    return true if $PokemonGlobal.partner
    return false if $player.able_pokemon_count <= 1
    return true if $PokemonSystem.battlesize == 1
    return true if $PokemonSystem.battlesize == 2 && !pbCanTripleBattle? && pbCanDoubleBattle?
    return true if $game_player.pbTerrainTag.double_wild_encounters && rand(100) < 30
    return false
  end





end



=begin



    ##### Main damage calculation #####
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=1 && target.pbOwnedByPlayer? && type == :DRAGON #BOSS 1
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=1 && target.pbOwnedByPlayer? && type == :GROUND #BOSS 1
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[255]>=2 && target.pbOwnedByPlayer? && type == :FAIRY	#BOSS 2
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[255]>=2 && target.pbOwnedByPlayer? && type == :FIRE	#BOSS 2
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=3 && target.pbOwnedByPlayer? && type == :ICE	#BOSS 3
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=3 && target.pbOwnedByPlayer? && type == :STEEL	#BOSS 3
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=4 && target.pbOwnedByPlayer? && type == :WATER	#BOSS 4
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=4 && target.pbOwnedByPlayer? && type == :DARK	#BOSS 4
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=5 && target.pbOwnedByPlayer? && type == :PSYCHIC	#BOSS 5
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=5&& target.pbOwnedByPlayer? && type == :NORMAL	#BOSS 5		
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=6 && target.pbOwnedByPlayer? && type == :FLYING	#BOSS 6
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=6 && target.pbOwnedByPlayer? && type == :FIGHTING	#BOSS 6
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=7 && target.pbOwnedByPlayer? && type == :GRASS	#BOSS 7
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=7 && target.pbOwnedByPlayer? && type == :ELECTRIC	#BOSS 7
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=8 && target.pbOwnedByPlayer? && type == :CRYSTAL	#BOSS 8
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=8 && target.pbOwnedByPlayer? && type == :BUG	#BOSS 8
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=9 && target.pbOwnedByPlayer? && type == :ROCK	#BOSS 9
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=9 && target.pbOwnedByPlayer? && type == :POISON	#BOSS 9
    
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=10&& target.pbOwnedByPlayer? && type == :WIND	#BOSS 10	
    multipliers[:base_damage_multiplier] *= 1.4 if $game_variables[234]>=10 && target.pbOwnedByPlayer? && type == :GHOST	#BOSS 10	
    
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = ((((2.0 * user.level / 5) + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
    # "AI-specific calculations below"
    # Increased critical hit rates
    if skill >= PBTrainerAI.mediumSkill
      c = 0
      # Ability effects that alter critical hit rate
      if c >= 0 && user.abilityActive?
        c = Battle::AbilityEffects.triggerCriticalCalcFromUser(user.ability, user, target, c)
      end
      if skill >= PBTrainerAI.bestSkill && c >= 0 && !moldBreaker && target.abilityActive?
        c = Battle::AbilityEffects.triggerCriticalCalcFromTarget(target.ability, user, target, c)
      end



=end



class Battle

  def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision == 1 && wildBattle? && @caughtPokemon.length > 0
    case oldDecision
    ##### WIN #####
    when 1
      PBDebug.log("")
      PBDebug.log("***Player won***")
      if trainerBattle?
        @scene.pbTrainerBattleSuccess
        case @opponent.length
        when 1
          pbDisplayPaused(_INTL("You defeated {1}!", @opponent[0].full_name))
        when 2
          pbDisplayPaused(_INTL("You defeated {1} and {2}!", @opponent[0].full_name,
                                @opponent[1].full_name))
        when 3
          pbDisplayPaused(_INTL("You defeated {1}, {2} and {3}!", @opponent[0].full_name,
                                @opponent[1].full_name, @opponent[2].full_name))
        end
        @opponent.each_with_index do |trainer, i|
          @scene.pbShowOpponent(i)
          msg = trainer.lose_text
          msg = "..." if !msg || msg.empty?
          pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
        end
      end
      # Gain money from winning a trainer battle, and from Pay Day
      pbGainMoney if @decision != 4
      # Hide remaining trainer
      @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length > 0
    ##### LOSE, DRAW #####
    when 2, 5
      PBDebug.log("")
      PBDebug.log("***Player lost***") if @decision == 2
      PBDebug.log("***Player drew with opponent***") if @decision == 5
      if @internalBattle
        pbDisplayPaused(_INTL("You have no more Pokémon that can fight!"))
        if trainerBattle?
          case @opponent.length
          when 1
            pbDisplayPaused(_INTL("You lost against {1}!", @opponent[0].full_name))
          when 2
            pbDisplayPaused(_INTL("You lost against {1} and {2}!",
                                  @opponent[0].full_name, @opponent[1].full_name))
          when 3
            pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",
                                  @opponent[0].full_name, @opponent[1].full_name, @opponent[2].full_name))
          end
        end
        if wildBattle?
          foeParty = pbParty(1)
          case foeParty.length
            when 1
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            $player.playerhealth -= rand(30)+5
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("The Wild {1} started charging at you!",foeParty[0].name))
          when 2
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            $player.playerhealth -= rand(30)+5
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("Oh! A wild {1} and {2} started charging at you!",foeParty[0].name,
               foeParty[1].name))
          when 3
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            $player.playerhealth -= rand(30)+5
		pbSEPlay("normaldamage")
            pbDisplayPaused(_INTL("The Wild {1}, {2} and {3} all started charging at once!",foeParty[0].name,
               foeParty[1].name,foeParty[2].name))
          end
      end
        # Lose money from losing a battle
        pbLoseMoney
        pbDisplayPaused(_INTL("You blacked out!")) if !@canLose
      elsif @decision == 2   # Lost in a Battle Frontier battle
        if @opponent
          @opponent.each_with_index do |trainer, i|
            @scene.pbShowOpponent(i)
            msg = trainer.win_text
            msg = "..." if !msg || msg.empty?
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/, pbPlayer.name))
          end
        end
      end
    ##### CAUGHT WILD POKÉMON #####
    when 4
      @scene.pbWildBattleSuccess if !Settings::GAIN_EXP_FOR_CAPTURE
    end
    # Register captured Pokémon in the Pokédex, and store them
    pbRecordAndStoreCaughtPokemon
    # Collect Pay Day money in a wild battle that ended in a capture
    pbGainMoney if @decision == 4
    # Pass on Pokérus within the party
    if @internalBattle
      infected = []
      $player.party.each_with_index do |pkmn, i|
        infected.push(i) if pkmn.pokerusStage == 1
      end
      infected.each do |idxParty|
        strain = $player.party[idxParty].pokerusStrain
        if idxParty > 0 && $player.party[idxParty - 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty - 1].givePokerus(strain)
        end
        if idxParty < $player.party.length - 1 && $player.party[idxParty + 1].pokerusStage == 0 && rand(3) == 0   # 33%
          $player.party[idxParty + 1].givePokerus(strain)
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      pbCancelChoice(b.index)   # Restore unused items to Bag
      Battle::AbilityEffects.triggerOnSwitchOut(b.ability, b, true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn, i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self, pkmn, @usedInBattle[0][i], true)   # Reset form
      pkmn.item = @initialItems[0][i]
    end
    return @decision
  end


end


class Interpreter
  def pbPushThisBoulder
   if $PokemonMap.strengthUsed
    pbPushThisEvent 
    return true
   elsif $player.playerstamina == $player.playermaxstamina
    $player.playerstamina = 0
    pbPushThisEvent 
    return true
   elsif $player.playerstamina < $player.playermaxstamina
     pbMessage(_INTL("If you had max stamina, or a Pokemon that knew Strength, you could push this boulder!"))
   end
  end



end


#===============================================================================
# Simple battler class for the wild Pokémon in a Safari Zone battle
#===============================================================================
class Battle::FakeBattler
  attr_reader :battle
  attr_reader :index
  attr_reader :pokemon
  attr_reader :owned
  attr_accessor :attackFactor
  attr_accessor :catchFactor
  attr_accessor :escapeFactor

  def initialize(battle, index)
    @battle  = battle
    @pokemon = battle.party2[0]
    @index   = index
    @attackFactor   = 0
    @catchFactor   = 0
    @escapeFactor   = 0
  end

  def pokemonIndex;   return 0;                     end
  def species;        return @pokemon.species;      end
  def gender;         return @pokemon.gender;       end
  def status;         return @pokemon.status;       end
  def hp;             return @pokemon.hp;           end
  def level;          return @pokemon.level;        end
  def name;           return @pokemon.name;         end
  def totalhp;        return @pokemon.totalhp;      end
  def displayGender;  return @pokemon.gender;       end
  def shiny?;         return @pokemon.shiny?;       end
  def super_shiny?;   return @pokemon.super_shiny?; end

  def isSpecies?(check_species)
    return @pokemon&.isSpecies?(check_species)
  end

  def fainted?;       return false; end
  def shadowPokemon?; return false; end
  def hasMega?;       return false; end
  def mega?;          return false; end
  def hasPrimal?;     return false; end
  def primal?;        return false; end
  def captured;       return false; end
  def captured=(value); end

  def owned?
    return $player.owned?(pokemon.species)
  end

  def pbThis(lowerCase = false)
    return (lowerCase) ? _INTL("the wild {1}", name) : _INTL("The wild {1}", name)
  end

  def opposes?(i)
    i = i.index if i.is_a?(Battle::FakeBattler)
    return (@index & 1) != (i & 1)
  end

  def pbReset; end
end

class Battle::Scene::CommandMenu < Battle::Scene::MenuBase
  def initialize(viewport, z)
    super(viewport)
    self.x = 0
    self.y = Graphics.height - 96
    # Create message box (shows "What will X do?")
    @msgBox = Window_UnformattedTextPokemon.newWithSize(
      "", self.x + 16, self.y + 2, 220, Graphics.height - self.y, viewport
    )
    @msgBox.baseColor   = TEXT_BASE_COLOR
    @msgBox.shadowColor = TEXT_SHADOW_COLOR
    @msgBox.windowskin  = nil
    addSprite("msgBox", @msgBox)
	 if $game_temp.in_safari.nil?
	   $game_temp.in_safari=false
	 end
    if USE_GRAPHICS && $game_temp.in_safari==false
      # Create background graphic
      background = IconSprite.new(self.x, self.y, viewport)
      background.setBitmap("Graphics/Pictures/Battle/overlay_command")
      addSprite("background", background)
      # Create bitmaps
      @buttonBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_command"))
      # Create action buttons
      @buttons = Array.new(4) do |i|   # 4 command options, therefore 4 buttons
        button = Sprite.new(viewport)
        button.bitmap = @buttonBitmap.bitmap
        button.x = self.x + Graphics.width - 260
        button.x += (i.even? ? 0 : (@buttonBitmap.width / 2) - 4)
        button.y = self.y + 6
        button.y += (((i / 2) == 0) ? 0 : BUTTON_HEIGHT - 4)
        button.y -= 10 if i > 1
        button.src_rect.width  = @buttonBitmap.width / 2
        button.src_rect.height = BUTTON_HEIGHT
        addSprite("button_#{i}", button)
        next button
      end
    else
      # Create command window (shows Fight/Bag/Pokémon/Run)
      @cmdWindow = Window_CommandPokemon.newWithSize(
        [], self.x + Graphics.width - 240, self.y, 240, Graphics.height - self.y, viewport
      )
      @cmdWindow.columns       = 2
      @cmdWindow.columnSpacing = 4
      @cmdWindow.ignore_input  = true
      addSprite("cmdWindow", @cmdWindow)
    end
    self.z = z
    refresh
  end
  def setTexts(value)
    @msgBox.text = value[0]
    return if USE_GRAPHICS && $game_temp.in_safari==false
    commands = []
    (1..4).each do |i|
	commands.push(value[i]) if value[i] 
	end
    @cmdWindow.commands = commands
  end
  def refreshButtons
	 if $game_temp.in_safari.nil?
	   $game_temp.in_safari=false
	 end
    return if !USE_GRAPHICS
    return if $game_temp.in_safari==true
    @buttons.each_with_index do |button, i|
      button.src_rect.x = (i == @index) ? @buttonBitmap.width / 2 : 0
      button.src_rect.y = MODES[@mode][i] * BUTTON_HEIGHT
      button.z          = self.z + ((i == @index) ? 3 : 2)
    end
  end

end

#===============================================================================
# Data box for safari battles
#===============================================================================
class Battle::Scene::SafariDataBox < Sprite
  attr_accessor :selected

  HP_BAR_CHANGE_TIME = 1.0
  STATUS_ICON_HEIGHT = 16
  def initialize(battle, viewport = nil)
    super(viewport)
    @selected    = 0
    @battle      = battle
    @databox     = AnimatedBitmap.new("Graphics/Pictures/Battle/databox_safari")
    self.x       = Graphics.width - 232
    self.y       = Graphics.height - 184
    @contents    = BitmapWrapper.new(@databox.width, @databox.height)
    self.bitmap  = @contents
    self.visible = false
    self.z       = 50
    pbSetSystemFont(self.bitmap)
    refresh
  end

  def refresh
    self.bitmap.clear
    self.bitmap.blt(0, 0, @databox.bitmap, Rect.new(0, 0, @databox.width, @databox.height))
    base   = Color.new(255, 255, 255)
    shadow = Color.new(0, 0, 0)
    textpos = []
	case @battle.index
	when 0 
	
	
	case $shifted1  
	 when 0
	  if !@battle.ballType.nil?
    textpos.push([_INTL("{1} x{2}",GameData::Item.get(@battle.ballType).name,$bag.quantity(@battle.ballType)), 30, 40, false, base, shadow])
	  else
    textpos.push([_INTL("No Ball"), 30, 40, false, base, shadow])
	  end
	 when 1
    textpos.push([_INTL("Pick POKeBALL"), 30, 40, false, base, shadow])
	end




	if Input.trigger?(Input::SHIFT)
	 if $shifted1==0
	  $shifted1=1
	 elsif $shifted1==1
	  $shifted1=0
	 end
	end

	when 1
	
	case $shifted2  
	 when 0
    textpos.push([_INTL("Bait x{1}", $bag.quantity(:BAIT)), 30, 40, false, base, shadow])
	 when 1
    textpos.push([_INTL("Act Friendly", $bag.quantity(:BAIT)), 30, 40, false, base, shadow])
	end

	
	
	
	if Input.trigger?(Input::SHIFT)
	 if $shifted2==0
	  $shifted2=1
	 elsif $shifted2==1
	  $shifted2=0
	 end
	end



	when 2  
	case $shifted3  
	 when 0
    textpos.push([_INTL("Stone x{2}", @battle.pbPlayer.name,$bag.quantity(:STONE)), 30, 40, false, base, shadow])
	 when 1
    textpos.push([_INTL("Punch", @battle.pbPlayer.name,$bag.quantity(:STONE)), 30, 40, false, base, shadow])
	 when 2
    textpos.push([_INTL("Machete", @battle.pbPlayer.name,$bag.quantity(:STONE)), 30, 40, false, base, shadow])
	end


	
	
	
	if Input.trigger?(Input::SHIFT)
	 if $shifted3==0
	  $shifted3=1
	 elsif $shifted3==1
	 
	  if $bag.has?(:MACHETE)
	  $shifted3=2
	  else
	  $shifted3=0
	  end
	 elsif $shifted3==2
	  $shifted3=0
	 end
	end



	when 3
	
	case $shifted4  
	 when 0
    textpos.push([_INTL("Run: {1}/{2} STA", $player.playerstamina,$player.playermaxstamina), 30, 40, false, base, shadow])
	 when 1
    textpos.push([_INTL("Rest: {1}/{2} STA", $player.playerstamina,$player.playermaxstamina), 30, 40, false, base, shadow])
	 when 2
    textpos.push([_INTL("Throw Pokeball"), 30, 40, false, base, shadow])
	end
	
	
	if Input.trigger?(Input::SHIFT)
	 if $shifted4==0
	  $shifted4=1
	 elsif $shifted4==1
	 
	  if $player.party.length>0
	  $shifted4=2
	  else
	  $shifted4=0
	  end
	 elsif $shifted4==2
	  $shifted4=0
	 end
	end




	end
    textpos.push([_INTL("{1}", @battle.pbPlayer.name), 30, 20, false, base, shadow])
    textpos.push([_INTL("{1}/{2} HP", $player.playerhealth,$player.playermaxhealth), 127, 20, false, base, shadow])
    pbDrawTextPositions(self.bitmap, textpos)
  end

  def update(frameCounter = 0)
    super()
  end
end



#===============================================================================
# Shows the player throwing bait at a wild Pokémon in a Safari battle.
#===============================================================================
class Battle::Scene::Animation::ThrowBait < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, battler)
    @battler = battler
    @trainer = battler.battle.pbGetOwnerFromBattlerIndex(battler.index)
    super(sprites, viewport)
  end

  def createProcesses
    # Calculate start and end coordinates for battler sprite movement
    batSprite = @sprites["pokemon_#{@battler.index}"]
    traSprite = @sprites["player_1"]
    ballPos = Battle::Scene.pbBattlerPosition(@battler.index, batSprite.sideSize)
    ballStartX = traSprite.x
    ballStartY = traSprite.y - (traSprite.bitmap.height / 2)
    ballMidX   = 0   # Unused in arc calculation
    ballMidY   = 122
    ballEndX   = ballPos[0] - 40
    ballEndY   = ballPos[1] - 4
    # Set up trainer sprite
    trainer = addSprite(traSprite, PictureOrigin::BOTTOM)
    # Set up bait sprite
    ball = addNewSprite(ballStartX, ballStartY,
                        "Graphics/Battle animations/safari_bait", PictureOrigin::CENTER)
    ball.setZ(0, batSprite.z + 1)
    # Trainer animation
    if traSprite.bitmap.width >= traSprite.bitmap.height * 2
      ballStartX, ballStartY = trainerThrowingFrames(ball, trainer, traSprite)
    end
    delay = ball.totalDuration   # 0 or 7
    # Bait arc animation
    ball.setSE(delay, "Battle throw")
    createBallTrajectory(ball, delay, 12,
                         ballStartX, ballStartY, ballMidX, ballMidY, ballEndX, ballEndY)
    ball.setZ(9, batSprite.z + 1)
    delay = ball.totalDuration
    ball.moveOpacity(delay + 8, 2, 0)
    ball.setVisible(delay + 10, false)
    # Set up battler sprite
    battler = addSprite(batSprite, PictureOrigin::BOTTOM)
    # Show Pokémon jumping before eating the bait
    delay = ball.totalDuration + 3
    2.times do
      battler.setSE(delay, "player jump")
      battler.moveDelta(delay, 3, 0, -16)
      battler.moveDelta(delay + 4, 3, 0, 16)
      delay = battler.totalDuration + 1
    end
    # Show Pokémon eating the bait
    delay = battler.totalDuration + 3
    2.times do
      battler.moveAngle(delay, 7, 5)
      battler.moveDelta(delay, 7, 0, 6)
      battler.moveAngle(delay + 7, 7, 0)
      battler.moveDelta(delay + 7, 7, 0, -6)
      delay = battler.totalDuration
    end
  end
end



#===============================================================================
# Shows the player throwing a rock at a wild Pokémon in a Safari battle.
#===============================================================================
class Battle::Scene::Animation::ThrowRock < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, battler)
    @battler = battler
    @trainer = battler.battle.pbGetOwnerFromBattlerIndex(battler.index)
    super(sprites, viewport)
  end

  def createProcesses
    # Calculate start and end coordinates for battler sprite movement
    batSprite = @sprites["pokemon_#{@battler.index}"]
    traSprite = @sprites["player_1"]
    ballStartX = traSprite.x
    ballStartY = traSprite.y - (traSprite.bitmap.height / 2)
    ballMidX   = 0   # Unused in arc calculation
    ballMidY   = 122
    ballEndX   = batSprite.x
    ballEndY   = batSprite.y - (batSprite.bitmap.height / 2)
    # Set up trainer sprite
    trainer = addSprite(traSprite, PictureOrigin::BOTTOM)
    # Set up bait sprite
    ball = addNewSprite(ballStartX, ballStartY,
                        "Graphics/Battle animations/safari_rock", PictureOrigin::CENTER)
    ball.setZ(0, batSprite.z + 1)
    # Trainer animation
    if traSprite.bitmap.width >= traSprite.bitmap.height * 2
      ballStartX, ballStartY = trainerThrowingFrames(ball, trainer, traSprite)
    end
    delay = ball.totalDuration   # 0 or 7
    # Bait arc animation
    ball.setSE(delay, "Battle throw")
    createBallTrajectory(ball, delay, 12,
                         ballStartX, ballStartY, ballMidX, ballMidY, ballEndX, ballEndY)
    ball.setZ(9, batSprite.z + 1)
    delay = ball.totalDuration
    ball.setSE(delay, "Battle damage weak")
    ball.moveOpacity(delay + 2, 2, 0)
    ball.setVisible(delay + 4, false)
    # Set up anger sprite
    anger = addNewSprite(ballEndX - 42, ballEndY - 36,
                         "Graphics/Battle animations/safari_anger", PictureOrigin::CENTER)
    anger.setVisible(0, false)
    anger.setZ(0, batSprite.z + 1)
    # Show anger appearing
    delay = ball.totalDuration + 5
    2.times do
      anger.setSE(delay, "Player jump")
      anger.setVisible(delay, true)
      anger.moveZoom(delay, 3, 130)
      anger.moveZoom(delay + 3, 3, 100)
      anger.setVisible(delay + 6, false)
      anger.setDelta(delay + 6, 96, -16)
      delay = anger.totalDuration + 3
    end
  end
end



#===============================================================================
# Safari Zone battle scene (the visuals of the battle)
#===============================================================================
class Battle::Scene
  def pbSafariStart
    @briefMessage = false
    @sprites["dataBox_0"] = SafariDataBox.new(@battle, @viewport)
	$shifted1=0
	$shifted2=0
	$shifted3=0
	$shifted4=0
    dataBoxAnim = Animation::DataBoxAppear.new(@sprites, @viewport, 0)
    loop do
      dataBoxAnim.update
      pbUpdate
      break if dataBoxAnim.animDone?
    end
    dataBoxAnim.dispose
	shift1 = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/cursor_shift"))
    shift = Sprite.new(@viewport)
    shift.bitmap = shift1.bitmap
    shift.x      = x = 4
    shift.y      = y = shift1.height+200
    shift.z      = 99
    @sprites["shiftButton"] = shift
    pbRefresh
  end
  
  
  def pbShowSafariWindow
    @sprites["commandWindow"].visible = true
    @sprites["messageBox"].visible    = true
  end
  
  def getCommands
   commands = []
	commands << _INTL("What will {1} do?", @battle.pbPlayer.name)
	commands << _INTL("CATCH")
	commands << _INTL("APPEAL") 
	commands << _INTL("ATTACK")
	commands << _INTL("DEFEND") 
	
	
  end

  def pbSafariCommandMenuEx(idxBattler,ball, mode = 3)
    texts = getCommands
    pbShowSafariWindow
    cw = @sprites["commandWindow"]
    cw.setTexts(texts)
    cw.setIndexAndMode(@lastCmd[idxBattler], mode)
    pbSelectBattler(idxBattler)
	@sprites["dataBox_0"].refresh
    ret = -1
    loop do
      oldIndex = cw.index
      pbUpdate(cw)
      # Update selected command
	  @sprites["dataBox_0"].refresh
#	  if Input.press?(Input::SHIFT)
#	  else
      if Input.trigger?(Input::LEFT)
        cw.index -= 1 if (cw.index & 1) == 1
      elsif Input.trigger?(Input::RIGHT)
        cw.index += 1 if (cw.index & 1) == 0
      elsif Input.trigger?(Input::UP)
        cw.index -= 2 if (cw.index & 2) == 2
      elsif Input.trigger?(Input::DOWN)
        cw.index += 2 if (cw.index & 2) == 0
      end
#	  end
    	@battle.index = cw.index
      pbPlayCursorSE if cw.index != oldIndex      # Actions
       texts = getCommands
       cw.setTexts(texts)
      if Input.trigger?(Input::USE)                 # Confirm choice
        pbPlayDecisionSE
        ret = cw.index
        @lastCmd[idxBattler] = ret
        break
      elsif Input.trigger?(Input::BACK) && mode == 1   # Cancel
        pbPlayCancelSE
        break
      elsif Input.trigger?(Input::F9) && $DEBUG    # Debug menu
        pbPlayDecisionSE
        ret = -2
        break
      end
    end
	@battle.index = ret
    return ret
  end
  
  def pbSafariCommandMenu(index,ball)
        pbSafariCommandMenuEx(index,ball, 3)
					
  end

  def pbThrowBait
    @briefMessage = false
    baitAnim = Animation::ThrowBait.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      baitAnim.update
      pbUpdate
      break if baitAnim.animDone?
    end
	increasedlikeness=50
	likelihood = rand(100)
	if $player.playerstamina > 50
	increasedlikeness+=5
	elsif $player.playerstamina > 90
	increasedlikeness+=10
	elsif $player.playerstamina > 75
	increasedlikeness+=7
	elsif $player.playerstamina < 25
	increasedlikeness-=5
	elsif $player.playerstamina < 10
	increasedlikeness-=7
	elsif $player.playerstamina <= 5
	increasedlikeness-=10
	end
    baitAnim.dispose
	if likelihood < increasedlikeness
       return true
	else 
	   return false
	end
  end

  def pbThrowRock
    @briefMessage = false
    rockAnim = Animation::ThrowRock.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      rockAnim.update
      pbUpdate
      break if rockAnim.animDone?
    end
	increasedlikeness=50
	likelihood = rand(100)
	if $player.playerstamina > 50
	increasedlikeness+=5
	elsif $player.playerstamina > 90
	increasedlikeness+=10
	elsif $player.playerstamina > 75
	increasedlikeness+=7
	elsif $player.playerstamina < 25
	increasedlikeness-=5
	elsif $player.playerstamina < 10
	increasedlikeness-=7
	elsif $player.playerstamina <= 5
	increasedlikeness-=10
	end
    rockAnim.dispose
	if likelihood < increasedlikeness
       return true
	else 
	   return false
	end
  end

  alias __safari__pbThrowSuccess pbThrowSuccess unless method_defined?(:__safari__pbThrowSuccess)

  def pbThrowSuccess
    __safari__pbThrowSuccess
    pbWildBattleSuccess if @battle.is_a?(SafariBattle)
  end
  def pbEndCombat
  pbWildBattleSuccess
  end
def pbSafariBalls
    # Fade out and hide all sprites
    visibleSprites = pbFadeOutAndHide(@sprites)
    # Set Bag starting positions
    oldLastPocket = $bag.last_viewed_pocket
    oldChoices    = $bag.last_pocket_selections.clone
    if @bagLastPocket
      $bag.last_viewed_pocket     = @bagLastPocket
      $bag.last_pocket_selections = @bagChoices
    else
      $bag.reset_last_selections
    end
    # Start Bag screen
    itemScene = PokemonBag_Scene.new
    itemScene.pbStartScene($bag, true,
                           proc { |item| useType = GameData::Item.get(item).is_pokeball?}, false)
    # Loop while in Bag screen
    wasTargeting = false
	item = 0
    loop do
      # Select an item
      item = itemScene.pbChooseItem
      break if !item
      # Choose a command for the selected item
      item = GameData::Item.get(item)
      itemName = item.name
      useType = item.is_pokeball?
      cmdUse = -1
      commands = []
      commands[cmdUse = commands.length] = _INTL("Select") if useType && useType != 0
      commands[commands.length]          = _INTL("Cancel")
      command = itemScene.pbShowCommands(_INTL("{1} is selected.", itemName), commands)
      break if cmdUse >= 0 && command == cmdUse   # Use
    end
    @bagLastPocket = $bag.last_viewed_pocket
    @bagChoices    = $bag.last_pocket_selections.clone
    $bag.last_viewed_pocket     = oldLastPocket
    $bag.last_pocket_selections = oldChoices
    # Close Bag screen
    itemScene.pbEndScene
    # Fade back into battle screen (if not already showing it)
    pbFadeInAndShow(@sprites, visibleSprites) if !wasTargeting
	return item
  end


  def pbCanSafariRun?(battler)
    pkmn = battler.pokemon
   return false if $player.playerstamina < 15
   return true if pkmn.types.include?(:GHOST)
   return true
  end

  def pbDisplayPausedMessage2(msg,autoclose=true)
    pbWaitMessage
    pbShowWindow(MESSAGE_BOX)
    cw = @sprites["messageWindow"]
    cw.text = msg + "\1"
    #PBDebug.log_message(msg)
    yielded = false
    timer_start = System.uptime
    loop do
      pbUpdate(cw)
      if !cw.busy?
        if !yielded
          yield if block_given?   # For playing SE as soon as the message is all shown
          yielded = true
        end
      end
      if Input.trigger?(Input::BACK) || Input.trigger?(Input::USE) || @abortable
        if cw.busy?
          pbPlayDecisionSE if cw.pausing? && !@abortable
          cw.skipAhead
        elsif !@abortable
          cw.text = ""
          pbPlayDecisionSE
          break
        end
      end
    end
  end
end



#===============================================================================
# Safari Zone battle class
#===============================================================================
#  attr_accessor :attackFactor
#  attr_accessor :catchFactor
#  attr_accessor :escapeFactor


class SafariBattle
  attr_reader   :battlers         # Array of fake battler objects
  attr_accessor :sideSizes        # Array of number of battlers per side
  attr_accessor :backdrop         # Filename fragment used for background graphics
  attr_accessor :backdropBase     # Filename fragment used for base graphics
  attr_accessor :time             # Time of day (0=day, 1=eve, 2=night)
  attr_accessor :environment      # Battle surroundings (for mechanics purposes)
  attr_reader   :weather
  attr_reader   :player
  attr_accessor :party2
  attr_accessor :canRun           # True if player can run from battle
  attr_accessor :canLose          # True if player won't black out if they lose
  attr_accessor :switchStyle      # Switch/Set "battle style" option
  attr_accessor :showAnims        # "Battle scene" option (show anims)
  attr_accessor :expGain          # Whether Pokémon can gain Exp/EVs
  attr_accessor :moneyGain        # Whether the player can gain/lose money
  attr_accessor :rules
  attr_accessor :ballCount
  attr_accessor :ballType
  attr_accessor :index
  attr_accessor :runrate

  include Battle::CatchAndStoreMixin

  def pbRandom(x); return rand(x); end

  #=============================================================================
  # Initialize the battle class
  #=============================================================================
  def initialize(scene, player, party2)
    @scene         = scene
    @peer          = Battle::Peer.new
    @backdrop      = ""
    @backdropBase  = nil
    @time          = 0
    @environment   = :None   # e.g. Tall grass, cave, still water
    @weather       = :None
    @decision      = 0
    @caughtPokemon = []
    @player        = [player]
    @party2        = party2
    @sideSizes     = [1, party2.length]
    @battlers      = [Battle::FakeBattler.new(self, 0),
                      Battle::FakeBattler.new(self, 1)]
    @rules         = {}
    @ballCount     = 0
    @cmd     = 0
	@target = 0
	@runrate = 5
	balls = $bag.withWhatPokeballs?
	if balls == false
	@ballType = nil
	
	else
	@ballType = $bag.withWhatPokeballs?[0]
	
	end
    @index     = 0
  end

  def disablePokeBalls=(value); end
  def sendToBoxes=(value); end
  def defaultWeather=(value); @weather = value; end
  def defaultTerrain=(value); end

  #=============================================================================
  # Information about the type and size of the battle
  #=============================================================================
  def wildBattle?;    return true;  end
  def trainerBattle?; return false; end

  def setBattleMode(mode); end

  def pbSideSize(index)
    return @sideSizes[index % 2]
  end

  #=============================================================================
  # Trainers and owner-related
  #=============================================================================
  def pbPlayer; return @player[0]; end
  def opponent; return nil;        end

  def pbGetOwnerFromBattlerIndex(idxBattler); return pbPlayer; end

  def pbSetSeen(battler)
    return if !battler || !@internalBattle
    if battler.is_a?(Battle::Battler)
      pbPlayer.pokedex.register(battler.displaySpecies, battler.displayGender,
                                battler.displayForm, battler.shiny?)
    else
      pbPlayer.pokedex.register(battler)
    end
  end

  def pbSetCaught(battler)
    return if !battler || !@internalBattle
    if battler.is_a?(Battle::Battler)
      pbPlayer.pokedex.register_caught(battler.displaySpecies)
    else
      pbPlayer.pokedex.register_caught(battler.species)
    end
  end

  #=============================================================================
  # Get party info (counts all teams on the same side)
  #=============================================================================
  def pbParty(idxBattler)
    return (opposes?(idxBattler)) ? @party2 : nil
  end

  def pbAllFainted?(idxBattler = 0); return false; end

  #=============================================================================
  # Battler-related
  #=============================================================================
  def opposes?(idxBattler1, idxBattler2 = 0)
    idxBattler1 = idxBattler1.index if idxBattler1.respond_to?("index")
    idxBattler2 = idxBattler2.index if idxBattler2.respond_to?("index")
    return (idxBattler1 & 1) != (idxBattler2 & 1)
  end

  def pbRemoveFromParty(idxBattler, idxParty); end
  def pbGainExp; end

  #=============================================================================
  # Messages and animations
  #=============================================================================
  def pbDisplay(msg, &block)
    @scene.pbDisplayMessage(msg, &block)
  end

  def pbDisplayPaused(msg, &block)
    @scene.pbDisplayPausedMessage(msg, &block)
  end
  def pbDisplayPaused2(msg, &block)
    @scene.pbDisplayPausedMessage2(msg, &block)
  end

  def pbDisplayBrief(msg)
    @scene.pbDisplayMessage(msg, true)
  end

  def pbDisplayConfirm(msg)
    return @scene.pbDisplayConfirmMessage(msg)
  end



  class BattleAbortedException < Exception; end

  def pbAbort
    raise BattleAbortedException.new("Battle aborted")
  end
  def tutorial_messages
  
	  pbDisplayPaused2(_INTL("That {1} really jumped you, huh?", pkmn.name))
	  pbDisplayPaused2(_INTL("You must not be that used to fighting POKeMON without... well..."))
	  pbDisplayPaused2(_INTL("POKeMON."))
	  pbDisplayPaused2(_INTL("This must be a lot then."))
	  pbDisplayPaused2(_INTL("You are gonna have to handle this {1} personally.",  pkmn.name))
	  pbDisplayPaused2(_INTL("You have four options available, CATCH, APPEAL, ATTACK, DEFEND."))
	  pbDisplayPaused2(_INTL("Each of them are actually multiple options, use the Shift button to shift through each. They remember what you last selected."))
	  pbDisplayPaused2(_INTL("You don't have any POKeBALLs, so you can't CATCH right now, but you can do other things."))
	  pbDisplayPaused2(_INTL("APPEAL would let you calm down the POKeMON to make it easier to run away, you can just talk to it, or give it things like food or bait."))
	  pbDisplayPaused2(_INTL("ATTACK would let you do damage to the POKeMON to perhaps kill it."))
	  pbDisplayPaused2(_INTL("Any weapons you create or find can be used under ATTACK."))
	  pbDisplayPaused2(_INTL("DEFEND allows you to run away, which requires Stamina, Rest, which recovers Stamina, or throw out your own POKeMON if you had any."))
	  pbDisplayPaused2(_INTL("I don't have to tell you there's no POKeMON Centers here in the Wilderness. Resting up might fix up a POKeMON if it's hurt, but it can't do anything if it's *dead*.")) if Nuzlocke.on? 
	  pbDisplayPaused2(_INTL("Every choice has a cost."))
	  pbDisplayPaused2(_INTL("Even so, you might be able to make some choices down the line to bring back the fallen.")) if Nuzlocke.on?
	  pbDisplayPaused2(_INTL("...but you can't bring back yourself.")) if $PokemonGlobal.hardcore == true
	  @see_tutorial_messages = true
  
  
  end
  def setup_balls
	    pokeballs = $bag.withWhatPokeballs?
		if pokeballs!=false
        if pokeballs.length > 0
        @ballType = pokeballs[0]
       end
	   end
  
  end
end


def pbLegendaryStarter3?(starter)
  return true if
    starter=="ARTICUNO" ||
    starter=="ZAPDOS" ||
    starter=="MOLTRES" ||
    starter=="MEWTWO" ||
    starter=="MEW" ||
    starter=="RAIKOU" ||
    starter=="ENTEI" ||
    starter=="SUICUNE" ||
    starter=="LUGIA" ||
    starter=="HOOH" ||
    starter=="CELEBI" ||
    starter=="REGIROCK" ||
    starter=="REGICE" ||
    starter=="REGISTEEL" ||
    starter=="LATIAS" ||
    starter=="LATIOS" ||
    starter=="KYOGRE" ||
    starter=="GROUDON" ||
    starter=="RAYQUAZA" ||
    starter=="JIRACHI" ||
    starter=="DEOXYS" ||
    starter=="UXIE" ||
    starter=="MESPRIT" ||
    starter=="AZELF" ||
    starter=="DIALGA" ||
    starter=="PALKIA" ||
    starter=="HEATRAN" ||
    starter=="REGIGIGAS" ||
    starter=="GIRATINA" ||
    starter=="CRESSELIA" ||
    starter=="MANAPHY" ||
    starter=="DARKRAI" ||
    starter=="SHAYMIN" ||
    starter=="ARCEUS" ||
    starter=="VICTINI" ||
    starter=="COBALION" ||
    starter=="TERRAKION" ||
    starter=="VIRIZION" ||
    starter=="TORNADUS" ||
    starter=="THUNDURUS" ||
    starter=="RESHIRAM" ||
    starter=="ZEKROM" ||
    starter=="LANDORUS" ||
    starter=="KYUREM" ||
    starter=="KELDEO" ||
    starter=="MELOETTA" ||
    starter=="GENESECT"||
    starter=="XERNEAS"||
    starter=="YVELTAL"||
    starter=="ZYGARDE"||
    starter=="TYPENULL"||
    starter=="SILVALLY"||
    starter=="TAPUBULU"||
    starter=="TAPUFINI"||
    starter=="TAPULELE"||
    starter=="TAPUKOKO"||
    starter=="COSMOG"||
    starter=="COSMOEM"||
    starter=="SOLGALEO"||
    starter=="LUNALA"||
    starter=="NECROZMA"||
    starter=="NIHILEGO"||
    starter=="ZACIAN"||
    starter=="ZAMAZENTA"||
    starter=="ETERNATUS"||
    starter=="KUBFU"||
    starter=="URSHIFU"||
    starter=="REGIELEKI"||
    starter=="REGIDRAGO"||
    starter=="GLASTRIER"||
    starter=="SPECTRIER"||
    starter=="CALYREX"
  return false
end

	
	def pbCanAttackPlayer2?(caller)
	  return false if GameData::MapMetadata.try_get($game_map.map_id)&.random_dungeon
	  return false if pbLegendaryStarter3?(caller.name.upcase)
      return false if caller.fainted?
      rate=15
      return false if rate==0
      rate*=2 if caller.shadowPokemon?
      rate*=3 if caller.hp>(caller.totalhp/4) && caller.hp<=(caller.totalhp/2)
      rate*=5 if caller.hp<=(caller.totalhp/4)
      rate*=1.5 if $player.playerstamina < 50 && $player.playerstamina > 25
      rate*=2 if $player.playerstamina < 25
      rate*=1.5 if $player.playerhealth < 50 && $player.playerhealth > 25
      rate*=2 if $player.playerhealth < 25
	  puts "rate: #{rate}"
	  chance = rand(100)
	  puts "chance: #{chance}"
	  puts "chance<rate: #{chance<rate}"
      return chance<=rate.to_i
    end
    
	def pbAttackPlayer2(caller)
      rate=10
      return if rate==0 # should never trigger anyways but you never know.
	  return if GameData::MapMetadata.try_get($game_map.map_id)&.random_dungeon
      pbDisplay(_INTL("{1} lunged at {2} for an attack!", pkmn.name,pbPlayer.name))
      rate=rate.to_f # don't want to lose decimal points
      intimidate=false
      rate*=1.2 if intimidate

      rate*=4.0 if $player.playerstamina < 50 && $player.playerstamina > 25
      rate*=5.0 if $player.playerstamina < 25
      rate*2.0 if pkmn.speed > player.shoespeed*2
      rate=rate.round # rounding it off.
  

  if rand<rate
	  if caller.shadowPokemon
        injury = rand(50)+1
        pbDisplay(_INTL("The incoming attack hits {2} for {1} Damage!", injury, pbPlayer.name))
        $player.playerhealth -= injury 
      else
        injury = rand(40)+1
        pbDisplay(_INTL("The incoming attack hits {2} for {1} Damage!", injury, pbPlayer.name))
        $player.playerhealth -= injury 
	  end
  else
     pbDisplay(_INTL("Thankfully, it missed!!"))
  end
    end


class SafariBattle
  #=============================================================================
  # Safari battle-specific methods
  #=============================================================================
 def pbEscapeRate(catch_rate)
    return 125 if catch_rate <= 45   # Escape factor 9 (45%)
    return 100 if catch_rate <= 60   # Escape factor 7 (35%)
    return 75 if catch_rate <= 120   # Escape factor 5 (25%)
    return 50 if catch_rate <= 250   # Escape factor 3 (15%)
    return 25                        # Escape factor 2 (10%)
  end
  def getRate(pkmn)
  
      rate=5
      rate+=2 if pkmn.shadowPokemon?
      rate*=3 if pkmn.hp>(pkmn.totalhp/4) && pkmn.hp<=(pkmn.totalhp/2)
      rate*=5 if pkmn.hp<=(pkmn.totalhp/4)
      rate+=5 if $player.playerstamina < 50 && $player.playerstamina > 25
      rate+=10 if $player.playerstamina < 25
      rate+=5 if $player.playerhealth < 50 && $player.playerhealth > 25
      rate+=15 if $player.playerhealth < 25
    return rate
  end

 
 
 def catching(pkmn)
 
 
		    case $shifted1
		     when 1
		       @ballType = @scene.pbSafariBalls
		       @ballType = GameData::Item.get(@ballType).id if !@ballType.nil?
			    @cmd = -1 if @ballType.nil? && pbDisplayPaused2(_INTL("You did not choose a POKeBALL!"))
		       return -1 if @ballType.nil?
	           @scene.pbUpdate
	           @scene.pbRefresh
			  when 0
			    if pbBoxesFull?
			   pbDisplay(_INTL("You can't catch any more Pokémon!")) 
		       return -1
			  end
		       if $bag.quantity(@ballType) == 0 || @ballType.nil?
		       @ballType = @scene.pbSafariBalls
			    @cmd = -1 if @ballType.nil? && pbDisplayPaused2(_INTL("You did not choose a POKeBALL!"))
		       return -1 if @ballType.nil?
		       @ballType = GameData::Item.get(@ballType).id if !@ballType.nil?
	           @scene.pbUpdate
	           @scene.pbRefresh
		       end
			   if @ballType
              $bag.remove(@ballType,1)
		       rare = (@battlers[@party2.length].catchFactor * 1275) / 100
		       if $player.decreaseStamina(5)
                pbThrowPokeBall(1, @ballType, rare, true)
		       
			   else
			     pbDisplayPaused2(_INTL("You overexerted yourself trying to throw a POKeBALL!"))
			   end
			   if @caughtPokemon.length > 0 && @party2.length==1
                pbRecordAndStoreCaughtPokemon
                @decision = 4
              end
              end
		     end
		
		
		
		
		
		
		




 
 
 
 end
 def appealing(pkmn)
      case $shifted2
	    when 1
          pbDisplayBrief(_INTL("{1} crouches down and acts friendly!", self.pbPlayer.name, @target.name))
		   $player.playerstamina += 2.0
          @battlers[@party2.index(pkmn)+1].catchFactor  +=5
          @battlers[@party2.index(pkmn)+1].escapeFactor -=5
           @runrate += 1
		   @cmd =5 
		when 0 
		
         if $bag.quantity(:BAIT) < 1
          pbDisplayBrief(_INTL("You do not have enough Bait!"))
         else
          pbDisplayBrief(_INTL("{1} threw some bait at the {2}!", self.pbPlayer.name, pkmn.name))
		  
		       if $player.decreaseStamina(5)
                baitresult = @scene.pbThrowBait
		        if baitresult == true
		                  pbDisplayBrief2(_INTL("It's looking at the bait curiously!"))
		                  @battlers[@party2.index(pkmn)+1].catchFactor  += 10
		                  @battlers[@party2.index(pkmn)+1].escapeFactor -= 10   
		                  @runrate *= 2
		        else
		                  pbDisplayBrief(_INTL("The bait flew past {1}", pkmn.name))
		        		  @cmd = 5
		        end
			   else
			     pbDisplayPaused2(_INTL("You overexerted yourself trying to throw bait!"))
			   end
                  
		  end



		
	  end




 end
 def attacking(pkmn)
    case $shifted3
	  when 2
	    if $player.decreaseStamina(10)
          pbDisplayBrief(_INTL("You attacked {1} with a Machete!", pkmn.name))
		  pkmn.hp -= rand(5)+12
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 5                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 7   # More likely to escape
		   @cmd = 7
		 else
			pbDisplayPaused2(_INTL("You overexerted yourself using your Machete!"))
		 end 
	  when 1
	    if $player.decreaseStamina(10)
		  pkmn.hp -= rand(5)+6
          pbDisplayBrief(_INTL("You punched the {1}!", pkmn.name))
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 7                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 5  # More likely to escape
		  @cmd = 7
		 else
			pbDisplayPaused2(_INTL("You overexerted yourself while punching!"))
		 end 
	  when 0		 
         if $bag.quantity(:STONE) < 1
          pbDisplayBrief(_INTL("You do not have enough Stones!"))
		  elsif decreaseStamina(10)
			pbDisplayPaused2(_INTL("You overexerted yourself throwing a Rock!"))
         else
          pbDisplayBrief(_INTL("{1} threw a rock at the {2}!", self.pbPlayer.name, @target.name))
          $bag.remove(:STONE,1)						
          rockresult = @scene.pbThrowRock
		  if rockresult == true
          @battlers[@party2.index(pkmn)+1].attackFactor  -= 10                       # Easier to catch
          @battlers[@party2.index(pkmn)+1].escapeFactor += 10   # More likely to escape
		   #pkmn.hp -= rand(10)+1
          pbDisplayBrief(_INTL("{1} seems to have taken some damage!", pkmn.name))
		  else
          pbDisplayBrief(_INTL("The rock flew past {1}!", pkmn.name))
		  @cmd = 5
		  end
         end

    end

 end
 def defending(pkmn)
			  @battlers[@party2.index(pkmn)+1].attackFactor+=10
          @battlers[@party2.index(pkmn)+1].catchFactor -= 10
 		 if Input.press?(Input::CTRL) && $DEBUG
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("You got away safely!"))
          @decision = 3
		 elsif $shifted4==1
		 





		 
		    if @battlers[@party2.index(pkmn)+1].attackFactor>10 && pbRandom(100) > (50+@battlers[@party2.index(pkmn)+1].attackFactor)
             pbDisplay(_INTL("Before {1} could even think of resting, {2} attacked!", self.pbPlayer.name,pkmn.name))
             $player.damagePlayer(rand(pkmn.attack.to_i)+1)
		      pbSEPlay("normaldamage")
			elsif (pbRandom(100)+@battlers[@party2.index(pkmn)+1].attackFactor) >= 25
             pbDisplayBrief(_INTL("{1} chose to rest!", self.pbPlayer.name))
			  $player.playerstamina += (rand(5)+15).to_f
			  $player.increaseHealth(rand(15)+5)
		      pbSEPlay("normaldamage")
			  if $player.playersaturation == 0.0
			  $player.playerfood -= (rand(5)+1).to_f
			  $player.playerwater -= (rand(5)+1).to_f
			  $player.playerfood = 0.0 if $player.playerfood<0.0
			  $player.playerwater = 0.0 if $player.playerwater<0.0
			  else
			  $player.playersaturation -= (rand(5)+1).to_f
			  end


			else
             pbDisplayBrief(_INTL("{1} tried to rest, but got attacked!", self.pbPlayer.name))
              $player.damagePlayer(rand(pkmn.attack.to_i)+1)
		       pbSEPlay("normaldamage")






		    end





			@cmd = 5
		 elsif $shifted4==2
		  if $player.party.length > 0 && !$player.party[0].egg?
         pbDisplayPaused(_INTL("You throw out #{$player.party[0].name}!"))
		  @decision = [5,pkmn]
		  else
         pbDisplayPaused(_INTL("You don't have any POKeMON!"))
           @cmd = 5
		  
		  end
		 elsif $player.playerhealth > 0
		       runInjury=rand(100)
		       injury = rand(pkmn.attack.to_i)+1
		       playercrit = rand(24)+1
			    if decreaseStamina(5)
				  random = pbRandom(100)
				
				  if @battlers[@party2.index(pkmn)+1].attackFactor>=10  && $player.playerstamina <= 25 && random<51
                     pbDisplayPaused(_INTL("{1} leaps at you and bits you when you attempt to move!",pkmn.name)) 
				       $player.damagePlayer(injury)
				  elsif @battlers[@party2.index(pkmn)+1].attackFactor>=10 && $player.playerstamina <= 25 && random>49
                     pbSEPlay("Battle flee")
                     pbDisplayPaused(_INTL("While you were running away, {1} attacked!",pkmn.name)) 
				       $player.damagePlayer(injury)
		              pbSEPlay("normaldamage")
                     @decision = 3
				  elsif @battlers[@party2.index(pkmn)+1].attackFactor>=10
                  pbDisplayPaused(_INTL("You don't try it! {1} seems too jumpy, and is ready to lunge if you move!",pkmn.name)) 
				  elsif $player.playerstamina <= 25
                   pbDisplayPaused(_INTL("You are far too tired to be able to get away!"))
				     return -1
				  elsif random<=@runrate
                   pbSEPlay("Battle flee")
                   pbDisplayPaused(_INTL("You got away safely!"))
                   @decision = 3
				  else 
                   pbDisplayPaused(_INTL("You cannot flee!"))
				  end









			    else
				
				
                pbDisplayPaused(_INTL("You don't have enough Stamina to dodge!"))
				end
               @runrate += 1
		 end
 end







 def player_turn
		 if @cmd==1 || @cmd==2 || (@cmd==0 && $shifted1!=1) 
		 
		 	if @party2.length > 1
		    command = []
		    @party2.each do |pkmn|
			  command << _INTL("#{pkmn.name}")
			
			end
		  
	        value = pbShowCommands("Who do you want to attack?", command, 0)
		     @target = @party2[value]
		  else
		    @target = @party2[0]
		  end

		 
		  else
		    @target = @party2[0]
		 
		 end



        case @cmd
        when 0   # Ball
		  catching(@target)
		 when 1

         appealing(@target)
		 when 2

         attacking(@target)
		 when 3
		  defending(@target)
		 end
 end

 #Command -1 == do not perform enemy turn
 #Command 0 == Catch
 #Command 1 == Appeal
 #Command 2 == Attack
 #Command 3 == defend
 #Command 5 == did nothing to enemy
 #Command 7 == Heavy Damage Reaction


 def enemy_turn(battler)
   return false if @cmd == -1
   pkmn = battler.pokemon
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
   puts tryFlee
   if (tryFlee || self.rules["alwaysflee"]) && @scene.pbCanSafariRun?(battler)
      pbDisplayPaused(_INTL("{1} fled from battle!", pkmn.name))
      @decision = 3
    return true
   end

   if pbCanAttackPlayer2?(pkmn) && battler.attackFactor > battler.escapeFactor
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
    end
   if @cmd == 2 && pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
   elsif @cmd == 2 
      pbDisplay(_INTL("{1} is angry!", pkmn.name))
   end
   if @cmd == 3 && pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
        return true
   elsif @cmd == 3 
      pbDisplay(_INTL("{1} is watching carefully!", pkmn.name))
   end
   if @cmd == 5
      pbDisplay(_INTL("{1} is watching carefully!", pkmn.name))
   end
   if @cmd == 7
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
     if @scene.pbCanSafariRun?(battler) && tryFlee
      pbDisplayPaused(_INTL("{1} limped away from battle!", pkmn.name))
      @decision = 3
		 return true
	  else
      pbDisplay(_INTL("{1} is nursing their wounds!", pkmn.name))
	  end
   end
   if @cmd == 0
   tryFlee= (battler.escapeFactor * 5 > pbRandom(100)) && battler.escapeFactor > battler.attackFactor
     randomized = pbRandom(100)
     if @scene.pbCanSafariRun?(battler) && tryFlee
      pbDisplayPaused(_INTL("{1} limped away from battle!", pkmn.name))
      @decision = 3
		 return true
	 elsif pbCanAttackPlayer2?(pkmn)
      pbDisplay(_INTL("{1} lunged at #{$player.name}!", pkmn.name))
        pbAttackPlayer2(pkmn)
		 return true
	  else
      pbDisplay(_INTL("{1} is nursing their wounds!", pkmn.name))
	  end
   end
   if @cmd == 1
     if $shifted2==1 #Be nice
       pbDisplay(_INTL("{1} looks at you curiously!", pkmn.name))
     
	  else #Bait
       pbDisplay(_INTL("{1} is eating!", pkmn.name))
	  
     end
   end

   return true
end


  def pbStartBattle
    begin
	
	  $player.playerstamina=0.0 if $player.playerstamina < 0.0
      pkmn = @party2[0]
      pbSetSeen(pkmn)
      @scene.pbStartBattle(self)
      pbDisplayPaused(_INTL("{1} was jumped by a wild {2}!", @battle.pbPlayer.name,pkmn.name)) if @party2.length==1
      pbDisplayPaused(_INTL("{1} was jumped by a wild {2}, and a wild {3}!", @battle.pbPlayer.name,pkmn.name,@party2[1].name)) if @party2.length==2
      @scene.pbSafariStart
	   @ballType = nil
	   @see_tutorial_messages = false
      weather_data = GameData::BattleWeather.try_get(@weather)
      @scene.pbCommonAnimation(weather_data.animation) if weather_data
      rate=getRate(pkmn)
      catch_rate = pkmn.species_data.catch_rate
	   @battlers.each_with_index do |pkmn, i|
	    if i!=0
      @battlers[i].catchFactor  = (catch_rate * 100) / 1275
      @battlers[i].catchFactor  = [[@battlers[i].catchFactor, 3].max, 20].min
      @battlers[i].escapeFactor = (pbEscapeRate(catch_rate) * 100) / 1275
      @battlers[i].escapeFactor = [[@battlers[i].escapeFactor, 2].max, 20].min
      @battlers[i].attackFactor  = (rate * 100) / 1275
      @battlers[i].attackFactor  = [[@battlers[i].attackFactor, 3].max, 20].min
	   end
	   end
	   #speed = pkmn.sp
	  
	  
	  #tutorial_messages if $game_switches[556]==true && @see_tutorial_messages == false
	  setup_balls if @ballType.nil?






      pbShowTipCardsGrouped(:BASICSCOMBAT) if $game_switches[556]==true
      loop do
	    $player.playerstamina=0.0 if $player.playerstamina < 0.0
	    @scene.pbUpdate
	    @scene.pbRefresh
	    #Player Turn
		
	    setup_balls if @ballType.nil?
        @cmd = @scene.pbSafariCommandMenu(0,@ballType)
        player_turn
        @battlers.each_with_index do |pkmn, i|
	    if i!=0
        @battlers[i].catchFactor  = [[@battlers[i].catchFactor, 3].max, 30].min
        @battlers[i].escapeFactor = [[@battlers[i].escapeFactor, 2].max, 20].min
        @battlers[i].attackFactor  = [[@battlers[i].attackFactor, 3].max, 40].min
	   end
		end
	    @scene.pbUpdate
	    @scene.pbRefresh
       @battlers.each_with_index do |battler, i|
	     next if i==0
        next if @decision != 0
	     pkmn = battler.pokemon
		 @decision = 1 if pkmn.fainted? && pbDisplayPaused(_INTL("You've knocked out {1}! ",pkmn.name))
		 next if pkmn.fainted?
        enemy_turn(battler)
       end

	    if $player.playerhealth <=0
		 pbDisplayPaused(_INTL("You've died to {1}! ",pkmn.name))
		 @decision = 2
		elsif pkmn.hp <= 0
		 pbDisplayPaused(_INTL("You've knocked out {1}! ",pkmn.name))
		 @decision = 1
		end



		if @decision.is_a?(Array)
        break if @decision[0] > 0
		else
        break if @decision > 0
		end
		
        weather_data = GameData::BattleWeather.try_get(@weather)
        @scene.pbCommonAnimation(weather_data.animation) if weather_data
        end

        @runrate += 1
		end




















		if !@decision.is_a?(Array)
	  if @decision == 1
		 pbDisplayPaused(_INTL("You collected some meat from {1}! ",pkmn.name))
		 pbCookMeat(false,pkmn,true)
        pbHeldItemDropOW(pkmn,true)
		 @scene.pbEndCombat
	  end
      else
	$game_temp.in_safari=false
     $game_temp.stop_intro_animations=true
     foe_party = WildBattle.generate_foes(@decision[1])
     WildBattle.start_core(*foe_party)
     $game_temp.stop_intro_animations=false
	  end
          
      @scene.pbEndBattle(@decision)
	  
	  
	  
    rescue BattleAbortedException
      @decision = 0
      @scene.pbEndBattle(@decision)
    end
  



end

class SafariState
  attr_accessor :ballcount
  attr_accessor :captures
  attr_accessor :decision
  attr_accessor :steps

  def initialize
    @start      = nil
    @ballcount  = 0
    @captures   = 0
    @inProgress = false
    @steps      = 0
    @decision   = 0
  end

  def pbReceptionMap
    return @inProgress ? @start[0] : 0
  end

  def inProgress?
    return @inProgress
  end


  def pbStart(ballcount)
    @start      = [$game_map.map_id, $game_player.x, $game_player.y, $game_player.direction]
    @ballcount  = $bag.amtwithFlag?
    @inProgress = true
    @steps      = Settings::SAFARI_STEPS
  end

  def pbEnd
    @start      = nil
    @ballcount  = 0
    @captures   = 0
    @inProgress = false
    @steps      = 0
    @decision   = 0
    $game_map.need_refresh = true
  end
end

#===============================================================================
#
#===============================================================================


def pbInSafari?
  return true if $player.able_pokemon_count == 0
  return true if $game_temp.in_safari==true
  return false
end

def pbSafariState
  $PokemonGlobal.safariState = SafariState.new if !$PokemonGlobal.safariState
  return $PokemonGlobal.safariState
end

#===============================================================================
#
#===============================================================================
EventHandlers.add(:on_enter_map, :end_safari_game,
  proc { |_old_map_id|
  }
)

EventHandlers.add(:on_player_step_taken_can_transfer, :safari_game_counter,
  proc { |handled|
  }
)

#===============================================================================
#
#===============================================================================
EventHandlers.add(:on_calling_wild_battle, :safari_battle,
  proc { |species, level, handled|
    # handled is an array: [nil]. If [true] or [false], the battle has already
    # been overridden (the boolean is its outcome), so don't do anything that
    # would override it again
    next if !handled[0].nil?
    next if !pbInSafari?
	
  encounter_type = $PokemonEncounters.encounter_type_on_tile(pos[0],pos[1])
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered_on_tile?(encounter_type, repel_active, true)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  pkmn = pbGenerateWildPokemon(encounter[0],encounter[1])
    handled[0] = pbSafariBattle(nil,nil,pkmn)
  }
)

def pbSafariBattle(species=nil, level=nil,pkmn=nil)
  # Generate a wild Pokémon based on the species and level
  if pkmn.nil?
  pkmn = pbGenerateWildPokemon(species, level)
  end
  foeParty = [pkmn]
  # Calculate who the trainer is
  playerTrainer = $player
  # Create the battle scene (the visual side of it)
  scene = BattleCreationHelperMethods.create_battle_scene
  # Create the battle class (the mechanics side of it)
  battle = SafariBattle.new(scene, playerTrainer, foeParty)
  battle.ballCount = $bag.amtwithFlag?
  BattleCreationHelperMethods.prepare_battle(battle)
  # Perform the battle itself
  decision = 0
  pbBattleAnimation(pbGetWildBattleBGM(foeParty), 0, foeParty) {
    pbSceneStandby {
      decision = battle.pbStartBattle
    }
  }
  Input.update
  # Save the result of the battle in Game Variable 1
  #    0 - Undecided or aborted
  #    1 - Pokemon KOed
  #    2 - Player KOed
  #    3 - Player or wild Pokémon ran from battle, or player forfeited the match
  #    4 - Wild Pokémon was caught
  if decision.is_a?(Array)
     
  pbSet(1, decision[0])
  EventHandlers.trigger(:on_wild_battle_end, species, level, decision[0])
  else
  pbSet(1, decision)
  EventHandlers.trigger(:on_wild_battle_end, species, level, decision)
  end
  # Used by the Poké Radar to update/break the chain
  # Return the outcome of the battle
  return decision
end

#===============================================================================
#
#===============================================================================
class PokemonPauseMenu
  alias __safari_pbShowInfo pbShowInfo unless method_defined?(:__safari_pbShowInfo)

  def pbShowInfo
    __safari_pbShowInfo
    return if !pbInSafari?
    if Settings::SAFARI_STEPS <= 0
      @scene.pbShowInfo(_INTL("Balls: {1}", pbSafariState.ballcount))
    else
      @scene.pbShowInfo(_INTL("Steps: {1}/{2}\nBalls: {3}",
                              pbSafariState.steps, Settings::SAFARI_STEPS, pbSafariState.ballcount))
    end
  end
end

MenuHandlers.add(:pause_menu, :quit_safari_game, {
  "name"      => _INTL("Quit"),
  "order"     => 60,
  "condition" => proc { next pbInSafari? },
  "effect"    => proc { |menu|
    menu.pbHideMenu
    if pbConfirmMessage(_INTL("Would you like to leave the Safari Game right now?"))
      menu.pbEndScene
      pbSafariState.decision = 1
      pbSafariState.pbGoToStart
      next true
    end
    menu.pbRefresh
    menu.pbShowMenu
    next false
  }
})


class PokemonBag

  def amtwithFlag?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.hasflagamt(@pockets[pocket])
  end
  
  def withWhatPokeballs?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.whatpkballs(@pockets[pocket])
  end

end

module ItemStorageHelper
  def self.hasflagamt(items)
    ret = 0
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0]).is_pokeball?
      ret = item_slot[1]
    end
    return ret
  end

  def self.whatpkballs(items)
    ret = []
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0]).is_pokeball?
      ret << item_slot[0]
    end
    return ret
  end

end

def pbCheckAllFainted
  if $player.able_pokemon_count == 0
    pbMessage(_INTL("You have no more Pokémon that can fight!\1"))
    pbMessage(_INTL("Be careful! Pokémon will only be targeting you!"))
  end
end


def pbBattleOnStepTaken(repel_active)
#  return if $player.able_pokemon_count == 0
  return if !$PokemonEncounters.encounter_possible_here?
  encounter_type = $PokemonEncounters.encounter_type
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered?(encounter_type, repel_active)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  if $PokemonEncounters.allow_encounter?(encounter, repel_active)
    if $PokemonEncounters.have_double_wild_battle?
      encounter2 = $PokemonEncounters.choose_wild_pokemon(encounter_type)
      EventHandlers.trigger(:on_wild_species_chosen, encounter2)
      WildBattle.start(encounter, encounter2, can_override: true)
    else
      WildBattle.start(encounter, can_override: true)
    end
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
  end
  $game_temp.force_single_battle = false
end





EventHandlers.add(:on_player_change_direction, :trigger_npmode,
  proc {
  if $player.able_pokemon_count == 0
    pbSafariState.pbStart(30)
  end
  }
)



module GameData
  class Item
    def is_pokeball?;            return has_flag?("PokeBall"); end
  end
end



class Battle::Peer


  def pbStorePokemon(player, pkmn)
    if !player.party_full?
      player.party[player.party.length] = pkmn
      return -1
    end
	
	
	
	
	if !$PokemonStorage.nil?
    oldCurBox = pbCurrentBox
    storedBox = $PokemonStorage.pbStoreCaught(pkmn)
    if storedBox < 0
      # NOTE: Poké Balls can't be used if storage is full, so you shouldn't ever
      #       see this message.
      pbDisplayPaused(_INTL("There's no place to put this if you catch it!"))
      return oldCurBox
    end
    return storedBox
	
	
	else
	 pbDisplayPaused(_INTL("There's no place to put this if you catch it!"))
	 
	 
	 
	 
	  return nil
	end
  end



  def pbCurrentBox
    return $PokemonStorage.currentBox if !$PokemonStorage.nil?
	return nil
  end



end







module Battle::CatchAndStoreMixin
  def pbStorePokemon(pkmn)
    # Nickname the Pokémon (unless it's a Shadow Pokémon)
    if !pkmn.shadowPokemon?
      if $PokemonSystem.givenicknames == 0 &&
         pbDisplayConfirm(_INTL("Would you like to give a nickname to {1}?", pkmn.name))
        nickname = @scene.pbNameEntry(_INTL("{1}'s nickname?", pkmn.speciesName), pkmn)
        pkmn.name = nickname
      end
    end
	pkmn.ace = false
	pkmn.lifespan = 50
	pkmn.food = (rand(100)+1)
    pkmn.water = (rand(100)+1)
    pkmn.age = (rand(40)+1)
  if pkmn.age <= 10
    pkmn.ev[:DEFENSE] = rand(40)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(40)
    pkmn.ev[:ATTACK] = rand(40)
    pkmn.ev[:SPECIAL_ATTACK] = rand(40)
    pkmn.ev[:SPEED] = rand(40)
    pkmn.ev[:HP] = rand(40)
  elsif pkmn.age <= 20 && pkmn.age > 10
    pkmn.ev[:DEFENSE] = rand(80)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(80)
    pkmn.ev[:ATTACK] = rand(80)
    pkmn.ev[:SPECIAL_ATTACK] = rand(80)
    pkmn.ev[:SPEED] = rand(80)
    pkmn.ev[:HP] = rand(80)
  elsif pkmn.age <= 30 && pkmn.age > 20
    pkmn.ev[:DEFENSE] = rand(120)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(120)
    pkmn.ev[:ATTACK] = rand(120)
    pkmn.ev[:SPECIAL_ATTACK] = rand(120)
    pkmn.ev[:SPEED] = rand(120)
    pkmn.ev[:HP] = rand(120)
  elsif pkmn.age <= 40 && pkmn.age > 30
    pkmn.ev[:DEFENSE] = rand(150)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(150)
    pkmn.ev[:ATTACK] = rand(150)
    pkmn.ev[:SPECIAL_ATTACK] = rand(150)
    pkmn.ev[:SPEED] = rand(150)
    pkmn.ev[:HP] = rand(150)
  elsif pkmn.age <= 51 && pkmn.age > 40
    pkmn.ev[:DEFENSE] = rand(200)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(200)
    pkmn.ev[:ATTACK] = rand(200)
    pkmn.ev[:SPECIAL_ATTACK] = rand(200)
    pkmn.ev[:SPEED] = rand(200)
    pkmn.ev[:HP] = rand(200)
  end
    # Store the Pokémon
     if $bag.has?(:MACHETE) && !pkmn.shadowPokemon? && !pkmn.egg? && !pkmn.foreign?($player)
      cmds = [_INTL("Add to your party"),
              _INTL("Send to a Box"),
              _INTL("See {1}'s summary", pkmn.name),
              _INTL("Use {1} for Food", pkmn.name),
              _INTL("Check party")]
     else
      cmds = [_INTL("Add to your party"),
              _INTL("Send to a Box"),
              _INTL("See {1}'s summary", pkmn.name),
              _INTL("Check party")]
     end
      cmds.delete_at(1) if @sendToBoxes == 2
      loop do
        @cmd = @scene.pbShowCommands(_INTL("Where do you want to send {1} to?", pkmn.name), cmds, 99)
        break if @cmd == 99   # Cancelling = send to a Box
        @cmd += 1 if @cmd >= 1 && @sendToBoxes == 2
        case @cmd
        when 0   # Add to your party
		   if $game_temp.in_safari==false
		   if pbPlayer.party.length>5
          pbDisplay(_INTL("Choose a Pokémon in your party to send to your Boxes."))
          party_index = -1
          @scene.pbPartyScreen(0, (@sendToBoxes != 2), 1) { |idxParty, _partyScene|
            party_index = idxParty
            next true
          }
          next if party_index < 0   # Cancelled
          party_size = pbPlayer.party.length
          send_pkmn = pbPlayer.party[party_index]
          stored_box = @peer.pbStorePokemon(pbPlayer, send_pkmn)
	        if !stored_box.nil?
          pbPlayer.party.delete_at(party_index)
          box_name = @peer.pbBoxName(stored_box)
          pbDisplayPaused(_INTL("{1} has been sent to Box \"{2}\".", send_pkmn.name, box_name))
          (party_index...party_size).each do |idx|
            if idx < party_size - 1
              @initialItems[0][idx] = @initialItems[0][idx + 1]
              $game_temp.party_levels_before_battle[idx] = $game_temp.party_levels_before_battle[idx + 1]
              $game_temp.party_critical_hits_dealt[idx] = $game_temp.party_critical_hits_dealt[idx + 1]
              $game_temp.party_direct_damage_taken[idx] = $game_temp.party_direct_damage_taken[idx + 1]
            else
              @initialItems[0][idx] = nil
              $game_temp.party_levels_before_battle[idx] = nil
              $game_temp.party_critical_hits_dealt[idx] = nil
              $game_temp.party_direct_damage_taken[idx] = nil
            end
          end
          end
          else
          stored_box = @peer.pbStorePokemon(pbPlayer, send_pkmn)
		  
          end


          else
		    break
          end
          break
        when 1   # Send to a Box
          break
        when 2   # See X's summary
          pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen([pkmn], 0)
          }
        when 3   # Check party
         if $bag.has?(:MACHETE) && !pkmn.shadowPokemon? && !pkmn.egg? && !pkmn.foreign?($player)
          pbCookMeat(false,pkmn)
          return
          else
          @scene.pbPartyScreen(0, true, 2)
          end
        when 4   # Check party
          @scene.pbPartyScreen(0, true, 2)
        end
      end

    # Store as normal (add to party if there's space, or send to a Box if not)
    stored_box = @peer.pbStorePokemon(pbPlayer, pkmn)
	 if !stored_box.nil?
    if stored_box < 0
      pbDisplayPaused(_INTL("{1} has been added to your party.", pkmn.name))
      @initialItems[0][pbPlayer.party.length - 1] = pkmn.item_id if @initialItems
      return
    end
    # Messages saying the Pokémon was stored in a PC box
    box_name = @peer.pbBoxName(stored_box)
    pbDisplayPaused(_INTL("{1} has been sent to Box \"{2}\"!", pkmn.name, box_name))
	end


  end

  def pbThrowPokeBall(idxBattler, ball, catch_rate = nil, showPlayer = false)
    # Determine which Pokémon you're throwing the Poké Ball at
    battler = nil
    if opposes?(idxBattler)
      battler = @battlers[idxBattler]
    else
      battler = @battlers[idxBattler].pbDirectOpposing(true)
    end
    battler = battler.allAllies[0] if battler.fainted?
    # Messages
    itemName = GameData::Item.get(ball).name
    if battler.fainted?
      if itemName.starts_with_vowel?
        pbDisplay(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
      else
        pbDisplay(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
      end
      pbDisplay(_INTL("But there was no target..."))
      return
    end
    if itemName.starts_with_vowel?
      pbDisplayBrief(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
    else
      pbDisplayBrief(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
    end
    # Animation of opposing trainer blocking Poké Balls (unless it's a Snag Ball
    # at a Shadow Pokémon)
    if trainerBattle? && !(GameData::Item.get(ball).is_snag_ball? && battler.shadowPokemon?)
      @scene.pbThrowAndDeflect(ball, 1)
      pbDisplay(_INTL("The Trainer blocked your Poké Ball! Don't be a thief!"))
      return
    end
    # Calculate the number of shakes (4=capture)
    pkmn = battler.pokemon
    @criticalCapture = false
    numShakes = pbCaptureCalc(pkmn, battler, catch_rate, ball)
    PBDebug.log("[Threw Poké Ball] #{itemName}, #{numShakes} shakes (4=capture)")
    # Animation of Ball throw, absorb, shake and capture/burst out
    @scene.pbThrow(ball, numShakes, @criticalCapture, battler.index, showPlayer)
    # Outcome message
    case numShakes
    when 0
      pbDisplay(_INTL("It's like the ball didn't even exist!"))
      $PokemonBag.pbStoreItem(ball) if $player.playerclass == "Catcher" && rand(100)<=20
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 1
      pbDisplay(_INTL("The Pokemon broke free easily!"))
      $PokemonBag.pbStoreItem(ball) if $player.playerclass == "Catcher" && rand(100)<=20
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 2
      pbDisplay(_INTL("Aargh! Almost had it!"))
      $PokemonBag.pbStoreItem(ball) if $player.playerclass == "Catcher" && rand(100)<=20
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 3
      pbDisplay(_INTL("Gah! It broke out, and it's not happy!"))
      $PokemonBag.pbStoreItem(ball) if $player.playerclass == "Catcher" && rand(100)<=20
      Battle::PokeBallEffects.onFailCatch(ball, self, battler)
    when 4
      pbDisplayBrief(_INTL("Gotcha! {1} was caught!", pkmn.name))
      @scene.pbThrowSuccess   # Play capture success jingle
      pbRemoveFromParty(battler.index, battler.pokemonIndex)
      # Gain Exp
      if Settings::GAIN_EXP_FOR_CAPTURE
        battler.captured = true
        pbGainExp
        battler.captured = false
      end
      battler.pbReset
      if pbAllFainted?(battler.index)
        @decision = (trainerBattle?) ? 1 : 4   # Battle ended by win/capture
      end
      # Modify the Pokémon's properties because of the capture
      if GameData::Item.get(ball).is_snag_ball?
        pkmn.owner = Pokemon::Owner.new_from_trainer(pbPlayer)
      end
      Battle::PokeBallEffects.onCatch(ball, self, pkmn)
      pkmn.poke_ball = ball
      pkmn.makeUnmega if pkmn.mega?
      pkmn.makeUnprimal
      pkmn.update_shadow_moves if pkmn.shadowPokemon?
      pkmn.record_first_moves
      # Reset form
      pkmn.forced_form = nil if MultipleForms.hasFunction?(pkmn.species, "getForm")
      @peer.pbOnLeavingBattle(self, pkmn, true, true)
      # Make the Poké Ball and data box disappear
      @scene.pbHideCaptureBall(idxBattler)
      # Save the Pokémon for storage at the end of battle
      @caughtPokemon.push(pkmn)
    end
    if numShakes != 4
      @first_poke_ball = ball if !@poke_ball_failed
      @poke_ball_failed = true
    end
  end

  #=============================================================================
  # Calculate how many shakes a thrown Poké Ball will make (4 = capture)
  #=============================================================================
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if $DEBUG && Input.press?(Input::CTRL)
    # Get a catch rate if one wasn't provided
    catch_rate = pkmn.species_data.catch_rate if !catch_rate
    # Modify catch_rate depending on the Poké Ball's effect
    if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
      catch_rate = Battle::PokeBallEffects.modifyCatchRate(ball, catch_rate, self, battler)
    else
      catch_rate /= 10
    end
	puts "#{catch_rate} Catch Rate"
    # First half of the shakes calculation
    a = battler.totalhp
    b = battler.hp
    x = (((3 * battler.totalhp) - (2 * battler.hp)) * catch_rate.to_f) / (3 * battler.totalhp)
    # Calculation modifiers
    if battler.status == :SLEEP || battler.status == :FROZEN
      x *= 2.5
    elsif battler.status != :NONE
      x *= 1.5
    elsif pbInSafari?
	  x /= 3.5
    end
    #INPUT CHECK EDIT
    if Input.repeat?(Input::ACTION)
      x *= 1.2
    end 
    x = x.floor
    x = 1 if x < 1
	puts "#{x} x"
    # Definite capture, no need to perform randomness checks
    return 4 if x >= 255 || Battle::PokeBallEffects.isUnconditional?(ball, self, battler)
    # Second half of the shakes calculation
    y = (65_536 / ((255.0 / x)**0.1875)).floor
    # Critical capture check
	puts "#{y} y"

      dex_modifier = 0
      numOwned = $player.pokedex.owned_count
      if numOwned > 600
        dex_modifier = 4
      elsif numOwned > 450
        dex_modifier = 3
      elsif numOwned > 300
        dex_modifier = 2
      elsif numOwned > 150
        dex_modifier = 1
      elsif numOwned > 30
        dex_modifier = 0.5
      end
      dex_modifier *= 2 if $bag.has?(:CATCHINGCHARM)
	puts "#{dex_modifier} dex_modifier"
      c = x * dex_modifier / 12
	puts "#{c} c"
      # Calculate the number of shakes
	if !pbInSafari?
      if c > 0 && pbRandom(256) < c
        @criticalCapture = true
        return 4 if pbRandom(65_536) < y
        return 0
      end
	end


    # Calculate the number of shakes
    numShakes = 0
    4.times do |i|
      break if numShakes < i
      numShakes += 1 if pbRandom(65_536) < y
    end
    return numShakes
  end
end


MenuHandlers.add(:debug_menu, :killme, {
  "name"        => _INTL("Kill me!"),
  "parent"      => :player_menu,
  "description" => _INTL("Kill the Player."),
  "effect"      => proc {
    $player.playerhealth = 0
  }
})