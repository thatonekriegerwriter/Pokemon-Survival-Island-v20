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
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty == 0 && rand(255)<= 75
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty <= 49 && rand(255)<= 50
    return pbDisobey(choice, badgeLevel) if @pokemon.loyalty <= 74 && rand(255)<= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 0 && r <= 50
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 149 && @pokemon.loyalty == 74 && r <= 20
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 0 && r <= 45
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 199 && @pokemon.loyalty == 74 && r <= 15
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 0 && r <= 40
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness >= 249 && @pokemon.loyalty == 74 && r <= 10
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 0 && r <= 35
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 49 && r <= 25
    return pbDisobey(choice, badgeLevel) if @pokemon.happiness == 250 && @pokemon.loyalty == 74 && r <= 5
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
  end
  
  
  
class PokemonEncounters
 # Returns whether a wild encounter should happen, based on its encounter
  # chance. Called when taking a step and by Rock Smash.
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
            pbDisplayPaused(_INTL("The Wild {1} started charging at you!",foeParty[0].name))
          when 2
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            $player.playerhealth -= rand(30)+5
            pbDisplayPaused(_INTL("Oh! A wild {1} and {2} started charging at you!",foeParty[0].name,
               foeParty[1].name))
          when 3
            pbDisplayPaused(_INTL("{1} panicked and tried to escape, but tripped!",self.pbPlayer.name))
            $player.playerhealth -= rand(30)+5
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

  def initialize(battle, index)
    @battle  = battle
    @pokemon = battle.party2[0]
    @index   = index
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



#===============================================================================
# Data box for safari battles
#===============================================================================
class Battle::Scene::SafariDataBox < Sprite
  attr_accessor :selected

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
    base   = Color.new(72, 72, 72)
    shadow = Color.new(184, 184, 184)
    textpos = []
    textpos.push([_INTL("Safari Balls"), 30, 14, false, base, shadow])
    textpos.push([_INTL("Left: {1}", @battle.ballCount), 30, 44, false, base, shadow])
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
    dataBoxAnim = Animation::DataBoxAppear.new(@sprites, @viewport, 0)
    loop do
      dataBoxAnim.update
      pbUpdate
      break if dataBoxAnim.animDone?
    end
    dataBoxAnim.dispose
    pbRefresh
  end

  def pbSafariCommandMenu(index)
    pbCommandMenuEx(index,
                    [_INTL("What will\n{1} throw?", @battle.pbPlayer.name),
                     _INTL("Ball"),
                     _INTL("Bait"),
                     _INTL("Rock"),
                     _INTL("Run")], 3)
  end

  def pbThrowBait
    @briefMessage = false
    baitAnim = Animation::ThrowBait.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      baitAnim.update
      pbUpdate
      break if baitAnim.animDone?
    end
    baitAnim.dispose
  end

  def pbThrowRock
    @briefMessage = false
    rockAnim = Animation::ThrowRock.new(@sprites, @viewport, @battle.battlers[1])
    loop do
      rockAnim.update
      pbUpdate
      break if rockAnim.animDone?
    end
    rockAnim.dispose
  end

  alias __safari__pbThrowSuccess pbThrowSuccess unless method_defined?(:__safari__pbThrowSuccess)

  def pbThrowSuccess
    __safari__pbThrowSuccess
    pbWildBattleSuccess if @battle.is_a?(SafariBattle)
  end
end



#===============================================================================
# Safari Zone battle class
#===============================================================================
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
    @sideSizes     = [1, 1]
    @battlers      = [Battle::FakeBattler.new(self, 0),
                      Battle::FakeBattler.new(self, 1)]
    @rules         = {}
    @ballCount     = 0
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

  def pbStartBattle
    begin
      pkmn = @party2[0]
      pbSetSeen(pkmn)
      @scene.pbStartBattle(self)
      pbDisplayPaused(_INTL("Wild {1} appeared!", pkmn.name))
      @scene.pbSafariStart
      weather_data = GameData::BattleWeather.try_get(@weather)
      @scene.pbCommonAnimation(weather_data.animation) if weather_data
      if $bag.quantity(:POKEBALL) > 0
      safariBall = GameData::Item.get(:POKEBALL).id
      elsif $bag.quantity(:GREATBALL) > 0
      safariBall = GameData::Item.get(:GREATBALL).id
      elsif $bag.quantity(:ULTRABALL) > 0
      safariBall = GameData::Item.get(:ULTRABALL).id
      elsif $bag.quantity(:SUPERBALL) > 0
      safariBall = GameData::Item.get(:SUPERBALL).id
      end
      catch_rate = pkmn.species_data.catch_rate
      catchFactor  = (catch_rate * 100) / 1275
      catchFactor  = [[catchFactor, 3].max, 20].min
      escapeFactor = (pbEscapeRate(catch_rate) * 100) / 1275
      escapeFactor = [[escapeFactor, 2].max, 20].min
      loop do
        cmd = @scene.pbSafariCommandMenu(0)
        case cmd
        when 0   # Ball
         if $bag.quantity(safariBall) == 0
          pbDisplayBrief(_INTL("You do not have enough POKeBALLs!"))
         end
          if pbBoxesFull?
            pbDisplay(_INTL("The boxes are full! You can't catch any more Pokémon!"))
            next
          end
          @ballCount -= 1
          @scene.pbRefresh
          rare = (catchFactor * 1275) / 100
          if safariBall
            pbThrowPokeBall(1, safariBall, rare, true)
            if @caughtPokemon.length > 0
              pbRecordAndStoreCaughtPokemon
              @decision = 4
            end
          end
        when 1   # Bait
         if $bag.quantity(:BAIT) < 1
          pbDisplayBrief(_INTL("You do not have enough Bait!"))
         else
          pbDisplayBrief(_INTL("{1} threw some bait at the {2}!", self.pbPlayer.name, pkmn.name))
          @scene.pbThrowBait
          catchFactor  /= 2 if pbRandom(100) < 90   # Harder to catch
          escapeFactor /= 2                       # Less likely to escape
		 end
        when 2   # Rock
         if $bag.quantity(:STONE) < 1
          pbDisplayBrief(_INTL("You do not have enough Stones!"))
         else
          pbDisplayBrief(_INTL("{1} threw a rock at the {2}!", self.pbPlayer.name, pkmn.name))
          $PokemonBag.pbDeleteItem(:STONE,1)						
          @scene.pbThrowRock
          catchFactor  *= 2                       # Easier to catch
          escapeFactor *= 2 if pbRandom(100) < 90   # More likely to escape
         end
        when 3   # Run
         if pbRandom(100)<=25
          pbDisplayPaused(_INTL("You cannot flee!"))
         elsif pbRandom(100)<=10
          pbDisplayPaused(_INTL("You cannot flee!"))
         elsif pbRandom(100)<=50 && ($player.playerstamina <= 10 || $player.playersleep <= 40)
          pbDisplayPaused(_INTL("You are far too tired to be able to get away!"))
         elsif pbRandom(100)<=50
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("You got away, but tripped on a rock!")) 
              $player.playerhealth -= 10
          @decision = 3
         elsif pbRandom(100)<=50 && catchFactor>=10				   
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("While you were running away, the POKeMON attacked!")) 
              $player.playerhealth -= 10
         elsif pbRandom(100)<=50 && catchFactor>=10 && ($player.playerstamina <= 10 || $player.playersleep <= 40)
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("While you were running away, the POKeMON attacked!")) 
          $player.playerhealth -= 40
         else
          pbSEPlay("Battle flee")
          pbDisplayPaused(_INTL("You got away safely!"))
          @decision = 3
		 end
        else
          next
        end
        catchFactor  = [[catchFactor, 3].max, 20].min
        escapeFactor = [[escapeFactor, 2].max, 20].min
        # End of round
        if @decision == 0
        elsif pbRandom(100) < 5 * escapeFactor
            pbSEPlay("Battle flee")
            pbDisplay(_INTL("{1} fled!", pkmn.name))
            @decision = 3
          elsif cmd == 1   # Bait
            pbDisplay(_INTL("{1} eats some of the food, watching wirily.",pkmn.name)) 
          elsif cmd==1 && pbRandom(100)<=25 # Bait
            pbDisplay(_INTL("{1} watches you wirily.",pkmn.name))
          elsif cmd==1 && escapeFactor >= 10 && pbRandom(100)<=25 # Bait
            pbDisplay(_INTL("{1} eats, but looks untrustworthy.",pkmn.name)) 
            pbDisplay(_INTL("{1} dashes at you for an attack!.",pkmn.name)) 
            if ($player.playerstamina <= 10 || $player.playersleep <= 40) && pbRandom(100)<=35
              pbDisplay(_INTL("You are too tired to dodge, and  get hit.",pkmn.name))
              $player.playerhealth -= 15
            elsif ($player.playerstamina <= 10 || $player.playersleep <= 40) && pbRandom(100)<=75
              pbDisplay(_INTL("Your body is lethargic, and you are hit hard.",pkmn.name)) 
              $player.playerhealth -= 30
            elsif pbRandom(100)<=15
              pbDisplay(_INTL("You are primed to dodge, but it moves fast, and hits you.",pkmn.name)) 
              $player.playerhealth -= 5
            else
              pbDisplay(_INTL("You dodge cleanly out of the way.",pkmn.name))
            end
          elsif cmd==1 && pbRandom(100)<=25 # Bait
            pbDisplay(_INTL("{1} eats some of the food, bringing its guard down more.",pkmn.name)) 
            catchFactor += 5
          elsif cmd==1 # Bait
            pbDisplay(_INTL("{1} munches on the bait.",pkmn.name))  
          elsif cmd==2 && pbRandom(100)<=25   # Rock
            pbDisplay(_INTL("{1} has been hit with a stone!",pkmn.name))
            pbDisplay(_INTL("It doesn't look happy!",pkmn.name))
          elsif cmd==2 && pbRandom(100)<=25 # Rock
            pbDisplay(_INTL("{1} is struck with the stone!",pkmn.name))
            pbDisplay(_INTL("It runs forwards and attacks!",pkmn.name))
            if ($player.playerstamina <= 10 || $player.playersleep <= 40)
              pbDisplay(_INTL("You are too tired to dodge, and  get hit.",pkmn.name))
              $player.playerhealth -= 15
            elsif ($player.playerstamina <= 10 || $player.playersleep <= 40)
              pbDisplay(_INTL("Your body is lethargic, and you are hit hard.",pkmn.name)) 
              $player.playerhealth -= 30
            elsif pbRandom(100)<=15
              pbDisplay(_INTL("You are primed to dodge, but it moves fast, and hits you.",pkmn.name)) 
              $player.playerhealth -= 5
            else
              pbDisplay(_INTL("You dodge cleanly out of the way.",pkmn.name))
            end
          else
            pbDisplay(_INTL("{1} is watching carefully!", pkmn.name))
          # Weather continues
          weather_data = GameData::BattleWeather.try_get(@weather)
          @scene.pbCommonAnimation(weather_data.animation) if weather_data
        end
        break if @decision > 0
      end
      @scene.pbEndBattle(@decision)
    rescue BattleAbortedException
      @decision = 0
      @scene.pbEndBattle(@decision)
    end
    return @decision
  end
end
