def pbDiveMap?(map_id)
  map_metadata = GameData::MapMetadata.try_get(map_id)
  return false if !map_metadata
  return true if map_metadata.dive_map_id
end



module OverworldPBEffects
  IsUnconditional = ItemHandlerHash.new
  ModifyCatchRate = ItemHandlerHash.new
  OnCatch         = ItemHandlerHash.new
  OnFailCatch     = ItemHandlerHash.new

  def self.isUnconditional?(ball, battler)
    ret = IsUnconditional.trigger(ball, battler)
    return (!ret.nil?) ? ret : false
  end

  def self.modifyCatchRate(ball, catchRate, battler)
    ret = ModifyCatchRate.trigger(ball, catchRate, battler)
    return (!ret.nil?) ? ret : catchRate
  end

  def self.onCatch(ball, pkmn)
    OnCatch.trigger(ball, pkmn)
  end

  def self.onFailCatch(ball, battler)
    $stats.failed_poke_ball_count += 1
    OnFailCatch.trigger(ball, battler)
  end
end

#===============================================================================
# IsUnconditional
#===============================================================================
OverworldPBEffects::IsUnconditional.add(:MASTERBALL, proc { |ball, battler|
  next true
})
OverworldPBEffects::IsUnconditional.add(:MASTERBALLC, proc { |ball, battler|
  next true
})
OverworldPBEffects::IsUnconditional.add(:PARKBALL, proc { |ball, battler|
  next true
})
#===============================================================================
# ModifyCatchRate
# NOTE: This code is not called if the battler is an Ultra Beast (except if the
#       Ball is a Beast Ball). In this case, all Balls' catch rates are set
#       elsewhere to 0.1x.
#===============================================================================
OverworldPBEffects::ModifyCatchRate.add(:GREATBALL, proc { |ball, catchRate, battler|
  next catchRate * 1.5
})
OverworldPBEffects::ModifyCatchRate.add(:GREATBALLC, proc { |ball, catchRate, battler|
  next catchRate * 1.5
})
OverworldPBEffects::ModifyCatchRate.add(:ULTRABALL, proc { |ball, catchRate, battler|
  next catchRate * 2
})
OverworldPBEffects::ModifyCatchRate.add(:ULTRABALLC, proc { |ball, catchRate, battler|
  next catchRate * 2
})
OverworldPBEffects::ModifyCatchRate.add(:SAFARIBALL, proc { |ball, catchRate, battler|
  next catchRate * 1.5
})

OverworldPBEffects::ModifyCatchRate.add(:NETBALL, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:BUG) || battler.pbHasType?(:WATER)
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:NETBALLC, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:BUG) || battler.pbHasType?(:WATER)
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:DIVEBALL, proc { |ball, catchRate, battler|
  catchRate *= 3.5 if pbDiveMap?($game_map.map_id)
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:DIVEBALLC, proc { |ball, catchRate, battler|
  catchRate *= 3.5 if pbDiveMap?($game_map.map_id)
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:NESTBALL, proc { |ball, catchRate, battler|
  if battler.level <= 30
    catchRate *= [(41 - battler.level) / 10.0, 1].max
  end
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:NESTBALLC, proc { |ball, catchRate, battler|
  if battler.level <= 30
    catchRate *= [(41 - battler.level) / 10.0, 1].max
  end
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:REPEATBALL, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if $player.owned?(battler.species)
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:REPEATBALLC, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if $player.owned?(battler.species)
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:TIMERBALL, proc { |ball, catchRate, battler|
  multiplier = [1 + (0.3 * timenow.wday), 4].min
  catchRate *= multiplier
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:TIMERBALLC, proc { |ball, catchRate, battler|
  multiplier = [1 + (0.3 * timenow.wday), 4].min
  catchRate *= multiplier
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:DUSKBALL, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3 : 3.5
  catchRate *= multiplier if PBDayNight.isNight?(pbGetTimeNow)
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:DUSKBALLC, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3 : 3.5
  catchRate *= multiplier if PBDayNight.isNight?(pbGetTimeNow)
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:QUICKBALL, proc { |ball, catchRate, battler|
  catchRate *= 5 if timenow.wday == 0
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:QUICKBALLC, proc { |ball, catchRate, battler|
  catchRate *= 5 if timenow.wday == 0
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:FASTBALL, proc { |ball, catchRate, battler|
  baseStats = battler.baseStats
  baseSpeed = baseStats[:SPEED]
  catchRate *= 4 if baseSpeed >= 100
  next [catchRate, 255].min
})
OverworldPBEffects::ModifyCatchRate.add(:FASTBALLC, proc { |ball, catchRate, battler|
  baseStats = battler.baseStats
  baseSpeed = baseStats[:SPEED]
  catchRate *= 4 if baseSpeed >= 100
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:LEVELBALL, proc { |ball, catchRate, battler|
  maxlevel = 0
  $player.party.each { |b| maxlevel = b.level if b.level > maxlevel }
  if maxlevel >= battler.level * 4
    catchRate *= 8
  elsif maxlevel >= battler.level * 2
    catchRate *= 4
  elsif maxlevel > battler.level
    catchRate *= 2
  end
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:LEVELBALLC, proc { |ball, catchRate, battler|
  maxlevel = 0						   
  $player.party.each { |b| maxlevel = b.level if b.level > maxlevel }
  if maxlevel >= battler.level * 4
    catchRate *= 8
  elsif maxlevel >= battler.level * 2
    catchRate *= 4
  elsif maxlevel > battler.level
    catchRate *= 2
  end
next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:LUREBALL, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 5 : 3
  catchRate *= multiplier if battler.pbHasType?(:WATER)
  next [catchRate, 255].min
})
OverworldPBEffects::ModifyCatchRate.add(:LUREBALLC, proc { |ball, catchRate, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 5 : 3
  catchRate *= multiplier if battler.pbHasType?(:WATER)
  next [catchRate, 255].min
})
OverworldPBEffects::ModifyCatchRate.add(:HEAVYBALL, proc { |ball, catchRate, battler|
  next 0 if catchRate == 0
  weight = battler.pbWeight
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
OverworldPBEffects::ModifyCatchRate.add(:HEAVYBALLC, proc { |ball, catchRate, battler|
  next 0 if catchRate == 0
  weight = battler.pbWeight
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

OverworldPBEffects::ModifyCatchRate.add(:LOVEBALL, proc { |ball, catchRate, battler|

	firstPkmn = $player.first_pokemon
    next if firstPkmn.species != battler.species
    next if firstPkmn.gender == battler.gender || firstPkmn.gender == 2 || battler.gender == 2
    catchRate *= 8
    break
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:LOVEBALLC, proc { |ball, catchRate, battler|
	firstPkmn = $player.first_pokemon
    next if firstPkmn.species != battler.species
    next if firstPkmn.gender == battler.gender || firstPkmn.gender == 2 || battler.gender == 2
    catchRate *= 8
    break
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:MOONBALL, proc { |ball, catchRate, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Moon Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  moon_stone = GameData::Item.try_get(:MOONSTONE)
  if moon_stone && battler.species_data.family_item_evolutions_use_item?(moon_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:MOONBALLC, proc { |ball, catchRate, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Moon Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  moon_stone = GameData::Item.try_get(:MOONSTONE)
  if moon_stone && battler.species_data.family_item_evolutions_use_item?(moon_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

OverworldPBEffects::ModifyCatchRate.add(:SPORTBALL, proc { |ball, catchRate, battler|
  next catchRate * 1.5
})

OverworldPBEffects::ModifyCatchRate.add(:SPORTBALLC, proc { |ball, catchRate, battler|
  next catchRate * 1.5
})

OverworldPBEffects::ModifyCatchRate.add(:DREAMBALL, proc { |ball, catchRate, battler|
  catchRate *= 4 if battler.status == :SLEEP
  next catchRate
})
OverworldPBEffects::ModifyCatchRate.add(:DREAMBALLC, proc { |ball, catchRate, battler|
  catchRate *= 4 if battler.status == :SLEEP
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:BEASTBALL, proc { |ball, catchRate, battler|
  if battler.species_data.has_flag?("UltraBeast")
    catchRate *= 5
  else
    catchRate /= 10
  end
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:BEASTBALLC, proc { |ball, catchRate, battler|
  if battler.species_data.has_flag?("UltraBeast")
    catchRate *= 5
  else
    catchRate /= 10
  end
  next catchRate
})

#===============================================================================
# OnCatch
#===============================================================================
OverworldPBEffects::OnCatch.add(:HEALBALL, proc { |ball, pkmn|
  pkmn.heal
})
OverworldPBEffects::OnCatch.add(:HEALBALLC, proc { |ball, pkmn|
  pkmn.heal
})

OverworldPBEffects::OnCatch.add(:FRIENDBALL, proc { |ball, pkmn|
  pkmn.happiness = 200
})


OverworldPBEffects::OnCatch.add(:FRIENDBALLC, proc { |ball, pkmn|
  pkmn.happiness = 200
})

OverworldPBEffects::ModifyCatchRate.add(:YOLOBALLC,proc{|ball,battler|
  firstPkmn = $player.first_pokemon
  catchRate*4 if firstPkmn.hp>=firstPkmn.totalhp/7
})

OverworldPBEffects::ModifyCatchRate.add(:HIGHBALLC,proc { |ball,catchRate,battler,ultraBeast|
  maxlevel = 0
  $player.party.each do |b|
    maxlevel = b.level if b.level>maxlevel
  end
  if maxlevel<=battler.level+8;    catchRate *= 5
  elsif maxlevel<=battler.level+4; catchRate *= 3
  elsif maxlevel<battler.level;    catchRate *= 1
  end
  next [catchRate,255].min
})

OverworldPBEffects::ModifyCatchRate.add(:DAWNBALLC,proc { |ball,catchRate,battler,ultraBeast|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3 : 3.5
  catchRate *= multiplier if PBDayNight.isMorning?(pbGetTimeNow)
  next catchRate
})


OverworldPBEffects::ModifyCatchRate.add(:SHOCKBALLC,proc { |ball,catchRate,battler,ultraBeast|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:ELECTRIC) 
  next catchRate
})


OverworldPBEffects::ModifyCatchRate.add(:TOXICBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 4 if battler.status == :POISON
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:STUNBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 4 if battler.status == :PARALYSIS
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:FREEZEBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 4 if battler.status == :FROZEN
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:BURNBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 4 if battler.status == :BURN
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:STATUSBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 3 if battler.status == :SLEEP
  catchRate *= 3 if battler.status == :BURN
  catchRate *= 3 if battler.status == :PARALYSIS
  catchRate *= 3 if battler.status == :POISON
  catchRate *= 3 if battler.status == :FROZEN
  next catchRate
})

OverworldPBEffects::ModifyCatchRate.add(:DEBUFFBALLC,proc { |ball,catchRate,battler,ultraBeast|
  catchRate *= 1.5
  next catchRate
})


OverworldPBEffects::ModifyCatchRate.add(:IMMUNEBALLC,proc{|ball,catchRate,battler|
   pbattler=$player.first_pokemon
   catchRate*=7/2 if (battler.pbHasType?(:FLYING) && pbattler.pbHasType?(:GROUND)) ||
   (battler.pbHasType?(:FAIRY) && pbattler.pbHasType?(:DRAGON)) ||
   (battler.pbHasType?(:DARK) && pbattler.pbHasType?(:PSYCHIC)) ||
   (battler.pbHasType?(:FLYING) && pbattler.pbHasType?(:GROUND)) ||
   (battler.pbHasType?(:STEEL) && pbattler.pbHasType?(:POISON)) ||
   (battler.pbHasType?(:GHOST) && pbattler.pbHasType?(:NORMAL)) ||
   (battler.pbHasType?(:GHOST) && pbattler.pbHasType?(:FIGHTING)) ||
   (battler.pbHasType?(:NORMAL) && pbattler.pbHasType?(:GHOST)) ||
   (battler.pbHasType?(:GROUND) && pbattler.pbHasType?(:ELECTRIC))
   next catchRate   
})


OverworldPBEffects::OnFailCatch.add(:BARBEDBALLC,proc{|ball,battler|
  battler.pbReduceHP((battler.hp/16).floor)
  pbMessage(_INTL("{1} was hurt by the Barbed Ball!",battler.name))
})


OverworldPBEffects::OnCatch.add(:HIDDENBALLC,proc { |ball,pkmn|
  pkmn.setAbility(2)
})

OverworldPBEffects::OnCatch.add(:SHADOWBALL,proc { |ball,pkmn|
  pkmn.makeShadow
})