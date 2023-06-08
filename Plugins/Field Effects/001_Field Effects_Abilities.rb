#============================================================================
#
#
#
#============================================================================

#		FIELD EFFECTS IN ORDER OF NUMBER
#
#	1|	Example Field

#==================================
# 		ABILITY CHANGES
#==================================

# OVERGROW

Battle::AbilityEffects::DamageCalcFromUser.add(:OVERGROW,
  proc { |ability, user, target, move, mults, baseDmg, type|
										# Example Field				
    if (user.hp <= user.totalhp / 3 || $game_temp.fieldEffectsBg == 1) && type == :GRASS
      mults[:attack_multiplier] *= 1.5
    end
  }
)

# EFFECT SPORE
Battle::AbilityEffects::OnBeingHit.add(:EFFECTSPORE,
  proc { |ability, user, target, move, battle|
    # NOTE: This ability has a 30% chance of triggering, not a 30% chance of
    #       inflicting a status condition. It can try (and fail) to inflict a
    #       status condition that the user is immune to.
    next if !move.pbContactMove?(user)
	# NOTE_2: Its stupidly easy to boost the chance of the ability triggering based on Field
	# as seen below
	if $game_temp.fieldEffectsBg == 1 # Example Field
	   next if battle.pbRandom(100) >= 60
	else
	   next if battle.pbRandom(100) >= 30
	end 
    r = battle.pbRandom(3)
    next if r == 0 && user.asleep?
    next if r == 1 && user.poisoned?
    next if r == 2 && user.paralyzed?
    battle.pbShowAbilitySplash(target)
    if user.affectedByPowder?(Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      case r
      when 0
        if user.pbCanSleep?(target, Battle::Scene::USE_ABILITY_SPLASH)
          msg = nil
          if !Battle::Scene::USE_ABILITY_SPLASH
            msg = _INTL("{1}'s {2} made {3} fall asleep!", target.pbThis,
               target.abilityName, user.pbThis(true))
          end
          user.pbSleep(msg)
        end
      when 1
        if user.pbCanPoison?(target, Battle::Scene::USE_ABILITY_SPLASH)
          msg = nil
          if !Battle::Scene::USE_ABILITY_SPLASH
            msg = _INTL("{1}'s {2} poisoned {3}!", target.pbThis,
               target.abilityName, user.pbThis(true))
          end
          user.pbPoison(target, msg)
        end
      when 2
        if user.pbCanParalyze?(target, Battle::Scene::USE_ABILITY_SPLASH)
          msg = nil
          if !Battle::Scene::USE_ABILITY_SPLASH
            msg = _INTL("{1}'s {2} paralyzed {3}! It may be unable to move!",
               target.pbThis, target.abilityName, user.pbThis(true))
          end
          user.pbParalyze(target, msg)
        end
      end
    end
    battle.pbHideAbilitySplash(target)
  }
)


# NOTE: If you want to lower the accuracy of Pokémon having X ability, 
#		do it as seen below.

# LONG REACH
Battle::AbilityEffects::AccuracyCalcFromUser.add(:LONGREACH,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 0.9 if $game_temp.fieldEffectsBg == 1 # Example Field
  }
)

# NOTE: As seen below, Solid Rock checks if the Move is Supereffective to then decrease its power.
#		Here, we are telling to verify if its Super-Effective OR Pokémon with Solid Rock is on Example Field
#		if yes, then all damage recieved is decreased.

# SOLID ROCK
Battle::AbilityEffects::DamageCalcFromTarget.add(:SOLIDROCK,
  proc { |ability, user, target, move, mults, baseDmg, type|
    if Effectiveness.super_effective?(target.damageState.typeMod) || 
		$game_temp.fieldEffectsBg == 1 # Example Field
      mults[:final_damage_multiplier] *= 0.75
    end
  }
)

# NOTE: As seen below, KEENEYE OnSwitchIn is skipped if the field ISNT the Example Field
#		its easier to use a 'next if x' than to do a 'if end' or 'if elsif end' 
#		Same thing is made for WATERABSORB and healing at the end of turn, skip if not on Example Field
#		skip if the bearer of the ability is airborne, and skip if the bearer cant be healed
#		Same deal for Water Compaction

# KEENEYE
Battle::AbilityEffects::OnSwitchIn.add(:KEENEYE,
  proc { |ability, battler, battle, switch_in|
    next if $game_temp.fieldEffectsBg != 1 # Example Field
    battler.pbRaiseStatStageByAbility(:EVASION, 1, battler)
  }
)

# WATER ABSORB 
Battle::AbilityEffects::EndOfRoundHealing.add(:WATERABSORB,
  proc { |ability, battler, battle|
    next if $game_temp.fieldEffectsBg != 1 # Example Field
	next if battler.airborne?
    next if !battler.canHeal?
    battler.pbRecoverHP(battler.totalhp / 16)
    battle.pbDisplay(_INTL("{1} restored a little HP!",battler.pbThis))
  }
)

# WATER COMPACTION
Battle::AbilityEffects::EndOfRoundEffect.add(:WATERCOMPACTION,
  proc { |ability, battler, battle|
    next if $game_temp.fieldEffectsBg != 1 # Example Field
	battler.pbRaiseStatStageByAbility(:DEFENSE, 2, battler) if battler.pbCanRaiseStatStage?(:DEFENSE, battler)
  }
)

# GRASS PELT
Battle::AbilityEffects::DamageCalcFromTarget.add(:GRASSPELT,
  proc { |ability, user, target, move, mults, baseDmg, type|
    if $game_temp.terrainEffectsBg == 1 # Grassy Terrain
      mults[:defense_multiplier] *= 1.5
    end
  }
)

# MIMICRY

Battle::AbilityEffects::OnSwitchIn.add(:MIMICRY,
  proc { |ability, battler, battle, switch_in|
    # NOTE: Mimicry isn't activated if terrainEffectsBg is lower than 1, which means that it cant be any of the terrains
	# 		which are numbered from 1 to 4.
	# 		I don't know a better way to do this sorry.
    next if $game_temp.terrainEffectsBg < 1 && $game_temp.fieldEffectsBg == 0 # If no Terrain and No Field
    Battle::AbilityEffects.triggerOnTerrainChange(ability, battler, battle, false)
  }
)

Battle::AbilityEffects::OnTerrainChange.add(:MIMICRY,
  proc { |ability, battler, battle, ability_changed|
    if $game_temp.fieldEffectsBg == 0
		if $game_temp.terrainEffectsBg < 1
	  	  # Revert to original typing
		  battle.pbShowAbilitySplash(battler)
		  battler.pbResetTypes
		  battle.pbDisplay(_INTL("{1} changed back to its regular type!", battler.pbThis))
		  battle.pbHideAbilitySplash(battler)
		end
    else
      # Change to new typing
	  checkedTerrainAbility = false
	  case $game_temp.terrainEffectsBg
		when 1 # Grassy Terrain
		  if GameData::Type.exists?(:GRASS)
			new_type = :GRASS
			checkedTerrainAbility = true
		  end
		when 2 # Misty Terrain
		  if GameData::Type.exists?(:FAIRY)
			new_type = :FAIRY
			checkedTerrainAbility = true
		  end
		when 3 # Electric Terrain
		  if GameData::Type.exists?(:ELECTRIC)
			new_type = :ELECTRIC
			checkedTerrainAbility = true
		  end
		when 4 # Psychic Terrain
		  if GameData::Type.exists?(:PSYCHIC)
			new_type = :PSYCHIC
			checkedTerrainAbility = true
		  end
	  end
	 if !checkedTerrainAbility
		case $game_temp.fieldEffectsBg
		  when 1 # Example Field
			new_type = :BUG
	    end
	 end
      new_type_name = nil
      if new_type
        type_data = GameData::Type.try_get(new_type)
        new_type = nil if !type_data
        new_type_name = type_data.name if type_data
      end
      if new_type
        battle.pbShowAbilitySplash(battler)
        battler.pbChangeTypes(new_type)
        battle.pbDisplay(_INTL("{1}'s type changed to {2}!", battler.pbThis, new_type_name))
        battle.pbHideAbilitySplash(battler)
      end
    end
  }
)

# SURGE SURFER
Battle::AbilityEffects::SpeedCalc.add(:SURGESURFER,
  proc { |ability, battler, mult|
    next mult * 2 if $game_temp.terrainEffectsBg == 3 # Electric Terrain
  }
)
