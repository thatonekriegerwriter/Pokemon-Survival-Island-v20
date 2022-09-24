#===============================================================================
# Various changes to the Battle::Move class.
#===============================================================================
class Battle::Move
  #-----------------------------------------------------------------------------
  # Rewrites Critical hit check.
  #-----------------------------------------------------------------------------
  def pbIsCritical?(user, target)
    return false if target.pbOwnSide.effects[PBEffects::LuckyChant] > 0
    c = 0
    if c >= 0 && user.abilityActive?
      c = Battle::AbilityEffects.triggerCriticalCalcFromUser(user.ability, user, target, c)
    end
    if c >= 0 && target.abilityActive? && !@battle.moldBreaker
      c = Battle::AbilityEffects.triggerCriticalCalcFromTarget(target.ability, user, target, c)
    end
    if c >= 0 && user.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromUser(user.item, user, target, c)
    end
    if c >= 0 && target.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromTarget(target.item, user, target, c)
    end
    return false if c < 0
    case pbCritialOverride(user,target)
    when 1  then return true
    when -1 then return false
    end
    return true if c > 50 # Merciless
    ratios = (Settings::NEW_CRITICAL_HIT_RATE_MECHANICS) ? [24, 8, 2, 1] : [16, 8, 4, 3, 2]
    r = @battle.pbRandom(ratios[c]).floor
    if r == 1 && Settings::AFFECTION_EFFECTS && @battle.internalBattle &&
       user.pbOwnedByPlayer? && user.affection_level == 5 && !target.mega?
      target.damageState.affection_critical = true
      return true
    end
    return user.hasFocusedStrike?
  end
  
  #-----------------------------------------------------------------------------
  # New calculation for Critical hit modifiers.
  #-----------------------------------------------------------------------------
  def pbCalcCritRatioModifiers(user, target, modifiers)
    c = 1.0
    # Ability and Item modifiers.
    if c >= 0 && user.abilityActive?
      c = Battle::AbilityEffects.triggerCriticalCalcFromUser(user.ability, user, target, c)
    end
    if c >= 0 && target.abilityActive? && !@battle.moldBreaker
      c = Battle::AbilityEffects.triggerCriticalCalcFromTarget(target.ability, user, target, c)
    end
    if c >= 0 && user.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromUser(user.item, user, target, c)
    end
    if c >= 0 && target.itemActive?
      c = Battle::ItemEffects.triggerCriticalCalcFromTarget(target.item, user, target, c)
    end
    # Other modifiers.
    c *= 1.75 if user.inHyperMode? && @type == :SHADOW
    c *= 1.75 if highCriticalRate? && !user.hasActiveAbility?(:SHEERFORCE)
    c *= 1.25 if @id == :SPACIALREND && user.isSpecies?(:PALKIA) && user.form == 1
    c *= 1.25 if PluginManager.installed?("ZUD Mechanics") && zMove? && highCriticalRate?
    modifiers[:crit_multiplier] = c
  end
  
  #-----------------------------------------------------------------------------
  # Rewrites Accuracy check.
  #-----------------------------------------------------------------------------
  def pbAccuracyCheck(user, target)
    return true if target.effects[PBEffects::Telekinesis] > 0
    return true if target.effects[PBEffects::Minimize] && tramplesMinimize? && Settings::MECHANICS_GENERATION >= 6
    baseAcc = pbBaseAccuracy(user, target)
    return true if baseAcc == 0
    modifiers = {}
    modifiers[:base_accuracy]  = baseAcc
    modifiers[:accuracy_stage] = 0
    modifiers[:evasion_stage]  = 0
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    pbCalcAccuracyModifiers(user, target, modifiers)
    return true if modifiers[:base_accuracy] == 0
    return true if user.hasFocusedShot? # Purposely checked first to override Focused Dodge.
    return false if target.hasFocusedDodge?
    threshold = modifiers[:base_accuracy]
    r = @battle.pbRandom(100)
    if Settings::AFFECTION_EFFECTS && @battle.internalBattle &&
       target.pbOwnedByPlayer? && target.affection_level == 5 && !target.mega?
      return true if r < threshold - 10
      target.damageState.affection_missed = true if r < threshold
      return false
    end
    return r < threshold
  end
  
  #-----------------------------------------------------------------------------
  # Adds Fog weather to Accuracy modifiers.
  #-----------------------------------------------------------------------------
  alias focus_pbCalcAccuracyModifiers pbCalcAccuracyModifiers
  def pbCalcAccuracyModifiers(user, target, modifiers)
    focus_pbCalcAccuracyModifiers(user, target, modifiers)
    if @battle.field.weather == :Fog
      modifiers[:accuracy_multiplier] *= 3 / 5.0
    end
  end
  
  #-----------------------------------------------------------------------------
  # Rewrites added effect and flinch chance calculations.
  #-----------------------------------------------------------------------------
  def pbAdditionalEffectChance(user, target, effectChance = 0)
    # Focused Guard makes the opponent's Focused Effect fail to trigger.
    return 0 if user.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
    return 0 if target.hasActiveAbility?(:SHIELDDUST) && !@battle.moldBreaker
    return 0 if PluginManager.installed?("ZUD Mechanics") && 
                target.effects[PBEffects::MaxRaidBoss] && 
                target.effects[PBEffects::RaidShield] > 0
    # Effect chance is now only ever 100 or 0.
    ret = (effectChance == 100 || @addlEffect == 100) ? 100 : 0
    ret = 100 if user.hasFocusedEffect?
    ret = 100 if $DEBUG && Input.press?(Input::CTRL)
    return ret
  end
  
  def pbFlinchChance(user, target)
    return 0 if flinchingMove?
    # Focused Guard makes the opponent's Focused Effect fail to trigger.
    return 0 if user.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
    return 0 if target.hasActiveAbility?(:SHIELDDUST) && !@battle.moldBreaker
    if user.hasFocusedEffect?
      if user.hasActiveAbility?(:STENCH, true) ||
         user.hasActiveItem?([:KINGSROCK, :RAZORFANG], true)
        return 100 # Guaranteed flinch
      end
    end
    return 0
  end
  
  #-----------------------------------------------------------------------------
  # Adds Focused Guard effect to damage calculation.
  #-----------------------------------------------------------------------------
  alias focus_pbCalcDamageMultipliers pbCalcDamageMultipliers
  def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    focus_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
    if !user.hasFocusedStrike?
      if target.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
        if @battle.pbSideBattlerCount(target) > 1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      end
    end
  end
end