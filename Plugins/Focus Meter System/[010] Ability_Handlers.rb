#===============================================================================
# Abilities with updated calculations.
#===============================================================================
Battle::AbilityEffects::AccuracyCalcFromUser.add(:COMPOUNDEYES,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.75
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:HUSTLE,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] /= 2.0 if move.physicalMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:HUSTLE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:attack_multiplier] *= 1.5 if move.physicalMove? && user.inAccuracyStyle?
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:VICTORYSTAR,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.75
  }
)

Battle::AbilityEffects::AccuracyCalcFromAlly.add(:VICTORYSTAR,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.3
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:TANGLEDFEET,
  proc { |ability, mods, user, target, move, type|
    if user.opposes?(target) && mods[:base_accuracy] > 50 && target.effects[PBEffects::Confusion] > 0
      mods[:base_accuracy] = 50
    end
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:SANDVEIL,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 2.0 if target.effectiveWeather == :Sandstorm
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:SNOWCLOAK,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 2.0 if target.effectiveWeather == :Hail
  }
)

Battle::AbilityEffects::CriticalCalcFromUser.add(:SUPERLUCK,
  proc { |ability, user, target, c|
    next c *= 1.75
  }
)

#===============================================================================
# Abilities with new messages upon triggering vs focused moves.
#===============================================================================
Battle::AbilityEffects::OnBeingHit.add(:NOGUARD,
  proc { |ability, user, target, move, battle|
    next if !target || target.fainted?
    next if !target.hasFocusedDodge?
    battle.pbShowAbilitySplash(user)
    msg = _INTL("{1} ignores {2}'s attempt to evade attacks!", user.pbThis, target.pbThis(true))
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} makes it impossible to evade attacks!", user.pbThis, user.abilityName)
    end
    battle.pbDisplay(msg)
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SHIELDDUST,
  proc { |ability, user, target, move, battle|
    next if !target || target.fainted?
    next if !user.hasFocusedEffect?
    next if !move.pbDamagingMove?
    battle.pbShowAbilitySplash(target)
    msg = _INTL("{1} negates any additional effects of moves!", target.pbThis)
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} negates any additional effects of moves!", target.pbThis, target.abilityName)
    end
    battle.pbDisplay(msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:BATTLEARMOR,
  proc { |ability, user, target, move, battle|
    next if !target || target.fainted?
    next if !user.hasFocusedStrike?
    next if !move.pbDamagingMove?
    battle.pbShowAbilitySplash(target)
    msg = _INTL("{1} is protected from critical hits!", target.pbThis)
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} protects it from critical hits!", target.pbThis, target.abilityName)
    end
    battle.pbDisplay(msg)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.copy(:BATTLEARMOR, :SHELLARMOR)

#===============================================================================
# Abilities updated to now trigger only as part of a Focused Effect.
#===============================================================================
Battle::AbilityEffects::PriorityBracketChange.add(:QUICKDRAW,
  proc { |ability, battler, subPri, battle|
    next 1 if subPri == 0 && battler.hasFocusedEffect?
  }
)

Battle::AbilityEffects::OnDealingHit.add(:POISONTOUCH,
  proc { |ability, user, target, move, battle|
    next if !target || target.fainted?
    next if !user.hasFocusedEffect?
    next if !move.contactMove?
    next if user.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?([:SHIELDDUST, :IMMUNITY]) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target, true)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    elsif target.pbCanPoison?(user, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} poisoned {3}!",user.pbThis, user.abilityName, target.pbThis(true))
      end
      target.pbPoison(user, msg)
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnDealingHit.add(:STENCH,
  proc { |ability, user, target, move, battle|
    next if !target || target.fainted?
    next if !user.hasFocusedEffect?
    next if target.movedThisRound?
    next if user.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?([:SHIELDDUST, :INNERFOCUS]) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target, true)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!",target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    else
      msg = _INTL("{1}'s odor may cause flinching!",user.pbThis)
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} may cause flinching!", user.pbThis, user.abilityName, target.pbThis(true))
      end
      battle.pbDisplay(msg)
    end
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# Abilities updated to now always trigger during a Focused Guard.
#===============================================================================
Battle::AbilityEffects::OnBeingHit.add(:CURSEDBODY,
  proc { |ability, user, target, move, battle|
    next if user.fainted?
    next if user.effects[PBEffects::Disable] > 0
    regularMove = nil
    user.eachMove do |m|
      next if m.id != user.lastRegularMoveUsed
      regularMove = m
      break
    end
    next if !regularMove || (regularMove.pp == 0 && regularMove.total_pp > 0)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if chance <= 70
    battle.pbShowAbilitySplash(target)
    if !move.pbMoveFailedAromaVeil?(target, user, Battle::Scene::USE_ABILITY_SPLASH)
      user.effects[PBEffects::Disable]     = 3
      user.effects[PBEffects::DisableMove] = regularMove.id
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s {2} was disabled!", user.pbThis, regularMove.name))
      else
        battle.pbDisplay(_INTL("{1}'s {2} was disabled by {3}'s {4}!",
           user.pbThis, regularMove.name, target.pbThis(true), target.abilityName))
      end
      battle.pbHideAbilitySplash(target)
      user.pbItemStatusCureCheck
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CUTECHARM,
  proc { |ability, user, target, move, battle|
    next if target.fainted?
    next if !move.pbContactMove?(user)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if chance <= 70
    battle.pbShowAbilitySplash(target)
    if user.pbCanAttract?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} made {3} fall in love!", target.pbThis,
           target.abilityName, user.pbThis(true))
      end
      user.pbAttract(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:EFFECTSPORE,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if chance <= 70
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

Battle::AbilityEffects::OnBeingHit.add(:FLAMEBODY,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if user.burned? || chance <= 70
    battle.pbShowAbilitySplash(target)
    if user.pbCanBurn?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} burned {3}!", target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbBurn(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:POISONPOINT,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if user.poisoned? || chance <= 70
    battle.pbShowAbilitySplash(target)
    if user.pbCanPoison?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} poisoned {3}!", target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbPoison(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:STATIC,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = (user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 0 : 100
    elsif user.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      chance = 0
    else
      chance = battle.pbRandom(100)
    end
    next if user.paralyzed? || chance <= 70
    battle.pbShowAbilitySplash(target)
    if user.pbCanParalyze?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} paralyzed {3}! It may be unable to move!",
           target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbParalyze(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::EndOfRoundHealing.add(:HEALER,
  proc { |ability, battler, battle|
    chance = (battler.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 100 : battle.pbRandom(100)
    next unless chance > 70
    battler.allAllies.each do |b|
      next if b.status == :NONE
      battle.pbShowAbilitySplash(battler)
      oldStatus = b.status
      b.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
      if !Battle::Scene::USE_ABILITY_SPLASH
        case oldStatus
        when :SLEEP
          battle.pbDisplay(_INTL("{1}'s {2} woke its partner up!", battler.pbThis, battler.abilityName))
        when :POISON
          battle.pbDisplay(_INTL("{1}'s {2} cured its partner's poison!", battler.pbThis, battler.abilityName))
        when :BURN
          battle.pbDisplay(_INTL("{1}'s {2} healed its partner's burn!", battler.pbThis, battler.abilityName))
        when :PARALYSIS
          battle.pbDisplay(_INTL("{1}'s {2} cured its partner's paralysis!", battler.pbThis, battler.abilityName))
        when :FROZEN
          battle.pbDisplay(_INTL("{1}'s {2} defrosted its partner!", battler.pbThis, battler.abilityName))
        end
      end
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::EndOfRoundHealing.add(:SHEDSKIN,
  proc { |ability, battler, battle|
    next if battler.status == :NONE
    chance = (battler.pbOwnSide.effects[PBEffects::FocusedGuard] > 0) ? 100 : battle.pbRandom(100)
    next unless chance > 70
    battle.pbShowAbilitySplash(battler)
    oldStatus = battler.status
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      case oldStatus
      when :SLEEP
        battle.pbDisplay(_INTL("{1}'s {2} woke it up!", battler.pbThis, battler.abilityName))
      when :POISON
        battle.pbDisplay(_INTL("{1}'s {2} cured its poison!", battler.pbThis, battler.abilityName))
      when :BURN
        battle.pbDisplay(_INTL("{1}'s {2} healed its burn!", battler.pbThis, battler.abilityName))
      when :PARALYSIS
        battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!", battler.pbThis, battler.abilityName))
      when :FROZEN
        battle.pbDisplay(_INTL("{1}'s {2} defrosted it!", battler.pbThis, battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)