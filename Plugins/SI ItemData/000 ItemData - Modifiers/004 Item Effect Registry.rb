EffectManager::OnFailCatch.add(:BARBED, proc { |ball, battler, battle|
  $stats.failed_poke_ball_count += 1
  if battle
    battle.scene.pbDamageAnimation(battler,0)
    battler.pbReduceHP((battler.totalhp/16).floor)
    battle.pbDisplayBrief(_INTL("{1} was hurt by the Barbed Ball!",battler.name))
  else
    battler.damage((battler.hp/16).floor)
    sideDisplay(_INTL("{1} was hurt by the Barbed Ball!", battler.name))
  end 
})

EffectManager::OnCatch.add(:HEAL, proc { |ball, pkmn, battle|
  pkmn.heal
})

EffectManager::OnCatch.add(:FRIENDSHIP, proc { |ball, pkmn, battle|
  pkmn.happiness = 200
})

EffectManager::OnCatch.add(:HIDDENABILITY, proc { |ball, pkmn, battle|
  pkmn.setAbility(2)
})

EffectManager::OnCatch.add(:SHADOW, proc { |ball, pkmn, battle|
  pkmn.makeShadow
})

EffectManager::ModifyCatchRate.add(:GREAT, proc { |ball, catchRate, battle, battler|
  next catchRate * 1.5
})

EffectManager::ModifyCatchRate.add(:ULTRA, proc { |ball, catchRate, battle, battler|
  next catchRate * 2
})

EffectManager::ModifyCatchRate.add(:NET, proc { |ball, catchRate, battle, battler|
  catchRate *= 3 if battler.pbHasType?(:BUG) || battler.pbHasType?(:WATER)
  next catchRate
})

EffectManager::ModifyCatchRate.add(:DIVE, proc { |ball, catchRate, battle, battler|
  if battle
  catchRate *= 3.5 if battle.environment == :Underwater
  else
  #catchRate *= 3.5 if battle.environment == :Underwater
  end 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:NEST, proc { |ball, catchRate, battle, battler|
  if battler.level <= 30
    catchRate *= [(41 - battler.level) / 10.0, 1].max
  end
  next catchRate
})

EffectManager::ModifyCatchRate.add(:REPEAT, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  if battle
  catchRate *= multiplier if battle.pbPlayer.owned?(battler.species)
  else
  catchRate *= multiplier if $player.owned?(battler.species)
  end 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:TIMER, proc { |ball, catchRate, battle, battler|
  if battle
  multiplier = [1 + (0.3 * battle.turnCount), 4].min
  else
   event = battler.event
   if event 
    steps = event.remaining_steps
    multiplier = [4 - (steps * 0.3), 1].max
   end
  end 
  catchRate *= multiplier
  next catchRate
})

EffectManager::ModifyCatchRate.add(:DUSK, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3 : 3.5
  if battle
  catchRate *= multiplier if battle.time == 2   # Night or in cave
  else
  catchRate *= multiplier if PBDayNight.isNight?
  end 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:QUICK, proc { |ball, catchRate, battle, battler|
  if battle
   catchRate *= 5 if battle.turnCount == 0
  else
   #VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
   event = battler.event
   if event 
    steps = event.remaining_steps
      if steps >= VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
        catchRate *= 5
      end
   end
  end
  next catchRate
})

EffectManager::ModifyCatchRate.add(:FAST, proc { |ball, catchRate, battle, battler|
  if battler.is_a?(Pokemon)
   baseStats = battler.baseStats
   baseSpeed = baseStats[:SPEED]
   catchRate *= 4 if baseSpeed >= 100
  else
   baseStats = battler.pokemon.baseStats
   baseSpeed = baseStats[:SPEED]
   catchRate *= 4 if baseSpeed >= 100
  end 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:LEVEL, proc { |ball, catchRate, battle, battler|
  maxlevel = 0
  if battle
  battle.allSameSideBattlers.each { |b| maxlevel = b.level if b.level > maxlevel }
  if maxlevel >= battler.level * 4
    catchRate *= 8
  elsif maxlevel >= battler.level * 2
    catchRate *= 4
  elsif maxlevel > battler.level
    catchRate *= 2
  end
  
  
  else
  $player.active_party.each { |b| maxlevel = b.level if b.level > maxlevel }
  if maxlevel >= battler.level * 4
    catchRate *= 8
  elsif maxlevel >= battler.level * 2
    catchRate *= 4
  elsif maxlevel > battler.level
    catchRate *= 2
  end
  
  end 
  next [catchRate, 255].min
})

EffectManager::ModifyCatchRate.add(:LURE, proc { |ball, catchRate, battle, battler|
   multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 5 : 3
  if battle
   catchRate *= multiplier if GameData::EncounterType.get($game_temp.encounter_type).type == :fishing
  
  else
   catchRate *= multiplier if battler.types.include?(:WATER)
  
  end
  
  
  next [catchRate, 255].min
})


EffectManager::ModifyCatchRate.add(:HEAVY, proc { |ball, catchRate, battle, battler|
  next 0 if catchRate == 0
  if battle
  weight = battler.pbWeight
  else
  weight = battler.weight
  end 
  if Settings::NEW_POKE_BALL_CATCH_RATES
    if weight >= 3000
      catchRate += 30
    elsif weight >= 2000
      catchRate += 20
    elsif weight < 1000
      catchRate -= 20
    end
  else
    if weight >= 4096
      catchRate += 40
    elsif weight >= 3072
      catchRate += 30
    elsif weight >= 2048
      catchRate += 20
    else
      catchRate -= 20
    end
  end
  next catchRate.clamp(1, 255)
})

EffectManager::ModifyCatchRate.add(:LOVE, proc { |ball, catchRate, battle, battler|
 if battle 
  battle.allSameSideBattlers.each do |b|
    next if b.species != battler.species
    next if b.gender == battler.gender || b.gender == 2 || battler.gender == 2
    catchRate *= 8
    break
  end
 else
    catchRate *= 2
 
 end 
  next [catchRate, 255].min
})

EffectManager::ModifyCatchRate.add(:MOON, proc { |ball, catchRate, battle, battler|
  moon_stone = GameData::Item.try_get(:MOONSTONE)
  if battle
  
  if moon_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(moon_stone.id)
    catchRate *= 4
  end
  else
  
  if moon_stone && battler.species_data.family_item_evolutions_use_item?(moon_stone.id)
    catchRate *= 4
  end
  
  end
  next catchRate
})


EffectManager::ModifyCatchRate.add(:DREAM, proc { |ball, catchRate, battle, battler|
  if battle
   catchRate *= 4 if battler.asleep?
  else 
  
  end
  next catchRate
})

EffectManager::ModifyCatchRate.add(:BEAST, proc { |ball, catchRate, battle, battler|
  if battle
   if battler.pokemon.species_data.has_flag?("UltraBeast")
    catchRate *= 5
   else
    catchRate /= 10
   end
  else
   if battler.species_data.has_flag?("UltraBeast")
    catchRate *= 5
   else
    catchRate /= 10
   end
  end
  next catchRate
})

EffectManager::ModifyCatchRate.add(:YOLO, proc { |ball, catchRate, battle, battler|
  if battle
   catchRate *= 4 if battler.damageState.initialHP<battler.totalhp/7 || battler.hp>=battler.totalhp/7
  else
   catchRate *= 4 if battler.hp>=battler.totalhp/7
  end
  next catchRate
})

EffectManager::ModifyCatchRate.add(:HIGH, proc { |ball, catchRate, battle, battler|
  maxlevel = 0
  if battle
  $player.party.each do |b|
    maxlevel = b.level if b.level>maxlevel
  end
  if maxlevel<=battler.level+8;    catchRate *= 5
  elsif maxlevel<=battler.level+4; catchRate *= 3
  elsif maxlevel<battler.level;    catchRate *= 1
  end
  
  else
  $player.active_party.each do |b|
    maxlevel = b.level if b.level>maxlevel
  end
  if maxlevel<=battler.level+8;    catchRate *= 5
  elsif maxlevel<=battler.level+4; catchRate *= 3
  elsif maxlevel<battler.level;    catchRate *= 1
  end
  
  end
  next [catchRate,255].min
})

EffectManager::ModifyCatchRate.add(:DAWN, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3 : 3.5
  if battle
   catchRate *= multiplier if battle.time == 1
  else
   catchRate *= multiplier if PBDayNight.isMorning?
  end 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:SHOCK, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:ELECTRIC) 
  next catchRate
})

EffectManager::ModifyCatchRate.add(:TOXIC, proc { |ball, catchRate, battle, battler|
  catchRate *= 5 if battler.status == :POISON
  next catchRate
})

EffectManager::ModifyCatchRate.add(:PARALYSIS, proc { |ball, catchRate, battle, battler|
  catchRate *= 5 if battler.status == :PARALYSIS
  next catchRate
})

EffectManager::ModifyCatchRate.add(:FROZEN, proc { |ball, catchRate, battle, battler|
  catchRate *= 5 if battler.status == :FROZEN
  next catchRate
})

EffectManager::ModifyCatchRate.add(:BURN, proc { |ball, catchRate, battle, battler|
  catchRate *= 5 if battler.status == :BURN
  next catchRate
})

EffectManager::ModifyCatchRate.add(:STATUS, proc { |ball, catchRate, battle, battler|
  catchRate *= 3 if battler.status == :SLEEP
  catchRate *= 3 if battler.status == :BURN
  catchRate *= 3 if battler.status == :PARALYSIS
  catchRate *= 3 if battler.status == :POISON
  catchRate *= 3 if battler.status == :FROZEN
  next catchRate
})

EffectManager::ModifyCatchRate.add(:DEBUFF, proc { |ball, catchRate, battle, battler|
  catchRate *= 4 if battler.statStageAtMin?
  next catchRate
})

EffectManager::ModifyCatchRate.add(:IMMUNE, proc { |ball, catchRate, battle, battler|
  if battle
   pbattler=battle.battlers[0]
   pbattler2=battle.battlers[2] if battle.battlers[2]
   catchRate*=7/2 if (battler.pbHasType?(:FLYING) && pbattler.pbHasType?(:GROUND)) ||
   (battler.pbHasType?(:FAIRY) && pbattler.pbHasType?(:DRAGON)) ||
   (battler.pbHasType?(:DARK) && pbattler.pbHasType?(:PSYCHIC)) ||
   (battler.pbHasType?(:FLYING) && pbattler.pbHasType?(:GROUND)) ||
   (battler.pbHasType?(:STEEL) && pbattler.pbHasType?(:POISON)) ||
   (battler.pbHasType?(:GHOST) && pbattler.pbHasType?(:NORMAL)) ||
   (battler.pbHasType?(:GHOST) && pbattler.pbHasType?(:FIGHTING)) ||
   (battler.pbHasType?(:NORMAL) && pbattler.pbHasType?(:GHOST)) ||
   (battler.pbHasType?(:GROUND) && pbattler.pbHasType?(:ELECTRIC))  
  else
  end
  next catchRate
})

EffectManager::IsUnconditional.add(:UNCONDITIONAL, proc { |ball, catchRate, battle, battler|
  next true
})