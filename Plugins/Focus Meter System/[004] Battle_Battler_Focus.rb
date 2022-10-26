#===============================================================================
# Focus meter calculations for each Focus Style.
#===============================================================================
class Battle::Battler
  #-----------------------------------------------------------------------------
  # Calculates the amount of focus each battler recieves after a move is used.
  #-----------------------------------------------------------------------------
  def pbBuildFocus(user, targets, move, numHits)
    return if $game_switches[Settings::NO_FOCUS_MECHANIC]
    # Builds focus when using a move.
    if ![:SLEEP, :FROZEN].include?(user.status)
      user.pbFullyFocused
      case user.effects[PBEffects::FocusStyle]
      when :Accuracy then pbAccuracyMeter(user, targets, move, numHits)
      when :Critical then pbCriticalMeter(user, targets, move, numHits)
      when :Potency  then pbPotencyMeter(user, targets, move, numHits)
      when :Passive  then pbPassiveMeter(user, targets, move, numHits)
      when :Enraged  then pbRageMeter(user, targets, move, numHits)
      end
    end
    # Builds target's focus when using a move.
    targets.each do |b|
      next if !b || b.fainted?
      next if b.status == :SLEEP || b.status == :FROZEN
      b.pbFullyFocusedOpp
      case b.effects[PBEffects::FocusStyle]
      when :Evasion then pbEvasionMeter(user, b, move, numHits)
      when :Passive then pbPassiveMeterOpp(user, b, move, numHits)
      when :Enraged then pbRageMeterOpp(user, b, move, numHits)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Returns true if a move has a function code cannot trigger focus.
  #-----------------------------------------------------------------------------
  def moveHasExceptionCode?(move)
    codes = ["SwitchOutUserPassOnEffects", "0ED"]
    case @effects[PBEffects::FocusStyle]
    when :Accuracy
      codes.push(
        "OHKO",
        "OHKOIce",
        "OHKOHitsUndergroundTarget",  "070",
        "CounterPhysicalDamage",      "071",
        "CounterSpecialDamage",       "072",
        "CounterDamagePlusHalf",      "073",
        "PursueSwitchingFoe",         "088",
        "AttackTwoTurnsLater",        "111"
      )
    when :Critical
      codes.push(
        "FixedDamage20",              "06A",
        "FixedDamage40",              "06B",
        "FixedDamageHalfTargetHP",    "06C",
        "FixedDamageUserLevel",       "06E",
        "FixedDamageUserLevelRandom", "06F",
        "OHKO", "OHKOIce",
        "OHKOHitsUndergroundTarget",  "070",
        "CounterPhysicalDamage",      "071",
        "CounterSpecialDamage",       "072",
        "CounterDamagePlusHalf",      "073",
        "AlwaysCriticalHit",          "0A0",
        "AttackTwoTurnsLater",        "111"
      )
    end
    return codes.include?(move.function)
  end
  
  #-----------------------------------------------------------------------------
  # Fills the entire meter when an effect fully focuses a battler. 
  #-----------------------------------------------------------------------------
  def pbFullyFocused
    return if !GameData::Focus.exists?(@effects[PBEffects::FocusStyle])
    return if focus_meter_full? || @effects[PBEffects::FocusLock] > 0
    if @effects[PBEffects::FullyFocused] > 0
      @effects[PBEffects::FullyFocused] = 0
      update_focus_meter(Settings::FOCUS_METER_SIZE)
    end
  end
  
  def pbFullyFocusedOpp
    return if !GameData::Focus.exists?(@effects[PBEffects::FocusStyle])
    return if focus_meter_full? || @effects[PBEffects::FocusLock] > 0
    focusitem = @damageState.focusSash || @damageState.focusBand 
    steadfast = (!movedThisRound? && @effects[PBEffects::Flinch] && hasActiveAbility?(:STEADFAST))
    if @effects[PBEffects::FullyFocused] > 0 || focusitem || steadfast # Focus Sash/Band, Steadfast Ability
      @effects[PBEffects::FullyFocused] = 0
      update_focus_meter(Settings::FOCUS_METER_SIZE)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Accuracy style.
  #-----------------------------------------------------------------------------
  def pbAccuracyMeter(user, targets, move, numHits)
    if user.focus_meter_full?
      user.reset_focus_meter if user.focus_trigger 
      return
    end
    return if user.effects[PBEffects::FocusLock] > 0
    return if user.effects[PBEffects::TwoTurnAttack]
    return if @battle.pbAllFainted?(user.idxOpposingSide)
    return if move.accuracy == 0
    return if user.moveHasExceptionCode?(move)
    base = Settings::FOCUS_METER_SIZE / 10.0
    total = 0
    modifiers = {}
    modifiers[:accuracy_stage]      = user.stages[:ACCURACY]
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    targets.each do |b|
	  next if !b || b.fainted? || !b.opposes?(user)
	  modifiers[:base_accuracy] = move.pbBaseAccuracy(user, b)
      modifiers[:evasion_stage] = b.stages[:EVASION]
      move.pbCalcAccuracyModifiers(user, b, modifiers)
      next if modifiers[:base_accuracy] == 0
      bonus = base
      bonus += (100 - modifiers[:base_accuracy]) / 2.0
      bonus += [0, base * (modifiers[:accuracy_stage] - modifiers[:evasion_stage])].max
      bonus += base if b.effects[PBEffects::Foresight] || b.effects[PBEffects::MiracleEye]
      bonus *= 1.3 if move.id == :FOCUSBLAST # Hidden bonus for Focus Miss.
      bonus *= modifiers[:accuracy_multiplier]
      bonus += (base / 2.0) * numHits if numHits > 1
      if b.damageState.missed
        bonus += Settings::FOCUS_METER_SIZE
      elsif b.damageState.substitute
        bonus /= 2.0
      elsif b.damageState.protected
        bonus /= 4.0
      elsif b.damageState.unaffected
        bonus = 0
      end
      total += (bonus > 0) ? bonus : 0
    end
    return if total == 0
    total /= targets.length if targets.length > 1
    if user.effects[PBEffects::FocusEnergy] > 0
      total *= user.effects[PBEffects::FocusEnergy]
    end
    total /= 2.0 if user.effects[PBEffects::DampenFocus]
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    user.update_focus_meter(total)
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Evasion style.
  #-----------------------------------------------------------------------------
  def pbEvasionMeter(attacker, target, move, numHits)
    return if target.focus_meter_full?
    return if target.effects[PBEffects::FocusLock] > 0
    return if attacker.effects[PBEffects::TwoTurnAttack]
    return if @battle.pbAllFainted?(target.idxOpposingSide)
    return if !target.opposes?(attacker) || target.fainted?
    modifiers = {}
    modifiers[:base_accuracy]       = move.pbBaseAccuracy(attacker, target)
    modifiers[:accuracy_stage]      = attacker.stages[:ACCURACY]
    modifiers[:evasion_stage]       = target.stages[:EVASION]
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    move.pbCalcAccuracyModifiers(attacker, target, modifiers)
    return if modifiers[:base_accuracy] == 0
    base = Settings::FOCUS_METER_SIZE / 10.0
    total = base
    total += (100 - modifiers[:base_accuracy]) / 2.0
    total += [0, base * (modifiers[:evasion_stage] - modifiers[:accuracy_stage])].max
    total += base if target.hasActiveItem?([:BRIGHTPOWDER, :LAXINCENSE])
    total *= modifiers[:evasion_multiplier]
    total *= 1.3 if target.hp <= target.totalhp / 2
    total += (base / 2.0) * numHits if numHits > 1
    if target.damageState.critical
      total += Settings::FOCUS_METER_SIZE
    end
    if target.effects[PBEffects::FocusEnergy] > 0
      total *= target.effects[PBEffects::FocusEnergy]
    end
    if target.effects[PBEffects::Foresight]  || 
       target.effects[PBEffects::MiracleEye] || 
       target.effects[PBEffects::DampenFocus]
      total /= 2.0
    end
    if target.damageState.substitute || target.damageState.protected 
      total /= 2.0
    end
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    target.update_focus_meter(total)
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Critical Hit style.
  #-----------------------------------------------------------------------------
  def pbCriticalMeter(user, targets, move, numHits)
    if user.focus_meter_full?
      user.reset_focus_meter if user.focus_trigger 
      return
    end
    return if user.effects[PBEffects::FocusLock] > 0
    return if user.effects[PBEffects::TwoTurnAttack]
    return if @battle.pbAllFainted?(user.idxOpposingSide)
    return if !move.damagingMove?
    return if user.moveHasExceptionCode?(move)
    base = Settings::FOCUS_METER_SIZE / 10.0
    total = 0
    modifiers  = {}
    modifiers[:crit_multiplier] = 1.0
    targets.each do |b|
      next if !b || b.fainted? || !b.opposes?(user)
      bonus = base
      bonus += [0, base * user.effects[PBEffects::CriticalBoost]].max
      # Target's raised Defense build more Focus when using physical moves.
      if move.physicalMove?
        bonus += (base * b.stages[:DEFENSE]) / 2.0 if b.stages[:DEFENSE] > 0
        bonus += base if b.pbOwnSide.effects[PBEffects::Reflect] > 0 || b.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      # Target's raised Sp.Def build more Focus when using special moves.
      elsif move.specialMove?
        bonus += (base * b.stages[:SPECIAL_DEFENSE]) / 2.0 if b.stages[:SPECIAL_DEFENSE] > 0
        bonus += base if b.pbOwnSide.effects[PBEffects::LightScreen] > 0 || b.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      end
      bonus += base if b.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      bonus += base if b.effects[PBEffects::Foresight] || b.effects[PBEffects::MiracleEye]
      move.pbCalcCritRatioModifiers(user, b, modifiers)
      bonus *= modifiers[:crit_multiplier]
      bonus += (base / 2.0) * numHits if numHits > 1
      if b.damageState.substitute
        bonus /= 2.0
      elsif b.damageState.protected
        bonus /= 4.0
      elsif b.damageState.unaffected || b.damageState.missed
        bonus = 0
      end
      total += bonus
    end
    return if total == 0
    total /= targets.length if targets.length > 1
    if user.effects[PBEffects::FocusEnergy] > 0
      total *= user.effects[PBEffects::FocusEnergy]
    end
    total /= 2.0 if user.effects[PBEffects::DampenFocus]
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    user.update_focus_meter(total)
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Potency style.
  #-----------------------------------------------------------------------------
  def pbPotencyMeter(user, targets, move, numHits)
    if user.focus_meter_full?
      user.reset_focus_meter if user.focus_trigger 
      return
    end
    return if user.effects[PBEffects::FocusLock] > 0
    return if user.effects[PBEffects::TwoTurnAttack]
    return if @battle.pbAllFainted?(user.idxOpposingSide)
    return if !user.hasAddedEffect?(move)
    base = Settings::FOCUS_METER_SIZE / 10.0
    # If any moves in the user's moveset contain these function codes,
    # no additional focus is gained from a move's added effect chance.
    freeze_codes = [
      "FreezeTarget",                           "00C", # Ice Beam, etc.
      "FreezeTargetAlwaysHitsInHail",           "00D", # Blizzard
      "FreezeFlinchTarget",                     "00E", # Ice Fang
      "FreezeTargetSuperEffectiveAgainstWater", "135"  # Freeze Dry
    ]
    omni_codes = ["RaiseUserMainStats1",        "02D"] # Ancient Power, etc.
    ignore_boost = false
    user.moves.each { |m| ignore_boost = true if omni_codes.include?(m.function) }
    user.moves.each { |m| ignore_boost = true if freeze_codes.include?(m.function) && !user.pbHasType?(:ICE) }
    # Effect rate gets applied to base Focus gained.
    effect_rate = (ignore_boost || [0, 100].include?(move.addlEffect)) ? base : move.addlEffect
    total = 0
    if targets.empty?
      bonus = effect_rate
      bonus *= 1.2 if user.hasActiveItem?([:LUCKYEGG, :LUCKINCENSE, :AMULETCOIN]) # Hidden bonus for "Luck" items.
      total += bonus
    else
      targets.each do |b|
        next if !b || b.fainted? || !b.opposes?(user)
        bonus = effect_rate
        bonus += base if b.effects[PBEffects::Foresight] || b.effects[PBEffects::MiracleEye]
        bonus *= 1.3 if user.hasActiveAbility?(:SERENEGRACE)
        bonus *= 1.2 if user.hasActiveItem?([:LUCKYEGG, :LUCKINCENSE, :AMULETCOIN]) # Hidden bonus for "Luck" items.
        bonus *= 4.0 if user.pbOwnSide.effects[PBEffects::Rainbow] > 0
        bonus += (base / 2.0) * numHits if numHits > 1
        if b.damageState.substitute
          bonus /= 2.0
        elsif b.damageState.protected || b.damageState.missed || b.damageState.unaffected
          bonus /= 4.0
        end
        total += bonus
      end
      total /= targets.length if targets.length > 1
    end
    if user.effects[PBEffects::FocusEnergy] > 0
      total *= user.effects[PBEffects::FocusEnergy]
    end
    total /= 2.0 if user.effects[PBEffects::DampenFocus]
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    user.update_focus_meter(total)
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Passive style.
  #-----------------------------------------------------------------------------
  def pbPassiveMeter(user, targets, move, numHits)
    return if user.focus_meter_full?
    return if user.effects[PBEffects::FocusLock] > 0
    return if @battle.pbAllFainted?(user.idxOpposingSide)
    return if move.damagingMove? # Only status moves increase Focus.
    base = Settings::FOCUS_METER_SIZE / 20.0
    total = 0
    if targets.empty?
      bonus = base
      bonus *= 3.0 if move.healingMove? && user.effects[PBEffects::HealBlock] == 0 && user.hp < user.totalhp
      total += bonus
    else
      targets.each do |b|
	    next if !b || b.fainted?
        bonus = base
        bonus *= 3.0 if move.healingMove? && b.effects[PBEffects::HealBlock] == 0 && b.hp < b.totalhp
        bonus += (base / 2.0) * numHits if numHits > 1
        total += bonus
        if b.damageState.substitute || b.damageState.protected || 
           b.damageState.missed     || b.damageState.unaffected
          bonus /= 2.0
        end
      end
    end
    return if total == 0
    total /= targets.length if targets.length > 1
    if user.effects[PBEffects::FocusEnergy] > 0
      total *= user.effects[PBEffects::FocusEnergy]
    end
    total /= 2.0 if user.effects[PBEffects::DampenFocus]
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    user.update_focus_meter(total)
  end
  
  def pbPassiveMeterOpp(attacker, target, move, numHits)
    return if target.focus_meter_full?
    return if target.effects[PBEffects::FocusLock] > 0
    return if @battle.pbAllFainted?(target.idxOpposingSide)
    return if !target.opposes?(attacker) || target.fainted?
    base = Settings::FOCUS_METER_SIZE / 10.0
    total = base
    # Target's raised Defense build more Focus when being hit by physical moves.
    if move.physicalMove?
      total += (base * target.stages[:DEFENSE]) / 2.0 if target.stages[:DEFENSE] > 0
      total += base if target.pbOwnSide.effects[PBEffects::Reflect] > 0 || target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
    # Target's raised Sp.Def build more Focus when being hit by special moves.
    elsif move.specialMove?
      total += (base * target.stages[:SPECIAL_DEFENSE]) / 2.0 if target.stages[:SPECIAL_DEFENSE] > 0
      total += base if target.pbOwnSide.effects[PBEffects::LightScreen] > 0 || target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
    end
    total += base if target.status != :NONE
    total += base if !target.movedThisRound? && target.effects[PBEffects::Flinch]
    total *= 1.3 if target.damageState.protected || target.damageState.substitute || target.hp <= target.totalhp / 2
    total *= 1.5 if attacker.hasFocusedShot? || attacker.hasFocusedEffect? || attacker.hasFocusedStrike?
    total += (base / 2.0) * numHits if numHits > 1
    if target.effects[PBEffects::FocusEnergy] > 0
      total *= target.effects[PBEffects::FocusEnergy]
    end
    if target.effects[PBEffects::Foresight]  || 
       target.effects[PBEffects::MiracleEye] || 
       target.effects[PBEffects::DampenFocus]
      total /= 2.0
    end
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    target.update_focus_meter(total)
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for battlers in the Enraged style.
  #-----------------------------------------------------------------------------
  def pbRageMeter(user, targets, move, numHits)
    return if user.focus_meter_full?
    return if user.effects[PBEffects::FocusLock] > 0
    return if @battle.pbAllFainted?(user.idxOpposingSide)
    return if !targets || targets.empty?
    base = Settings::FOCUS_METER_SIZE / 20.0
    total = 0
    modifiers  = {}
    modifiers[:base_accuracy]       = 0
    modifiers[:accuracy_stage]      = user.stages[:ACCURACY]
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    modifiers[:crit_multiplier]     = 1.0
    targets.each do |b|
      next if !b || !b.opposes?(user) || b.damageState.missed
      #-------------------------------------------------------------------------
      # Accuracy, Critical Hit, and Potency modifiers.
      #-------------------------------------------------------------------------
      modifiers[:evasion_stage] = b.stages[:EVASION]
      move.pbCalcAccuracyModifiers(user, b, modifiers)
      move.pbCalcCritRatioModifiers(user, b, modifiers)
      bonus = base
      bonus += [0, base * (modifiers[:accuracy_stage] - modifiers[:evasion_stage])].max
      bonus += [0, base * user.effects[PBEffects::CriticalBoost]].max
      if move.physicalMove?
        bonus += (base * b.stages[:DEFENSE]) / 2.0 if b.stages[:DEFENSE] > 0
        bonus += base if b.pbOwnSide.effects[PBEffects::Reflect] > 0 || b.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      elsif move.specialMove?
        bonus += (base * b.stages[:SPECIAL_DEFENSE]) / 2.0 if b.stages[:SPECIAL_DEFENSE] > 0
        bonus += base if b.pbOwnSide.effects[PBEffects::LightScreen] > 0 || b.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      end
      bonus += base if b.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      bonus += base if b.effects[PBEffects::Foresight] || b.effects[PBEffects::MiracleEye]
      bonus *= modifiers[:accuracy_multiplier] * modifiers[:crit_multiplier]
      bonus *= 1.3 if move.id == :FOCUSBLAST
      bonus *= 1.3 if user.hasActiveAbility?(:SERENEGRACE)
      bonus *= 1.2 if user.hasActiveItem?([:LUCKYEGG, :LUCKINCENSE, :AMULETCOIN])
      bonus *= 4.0 if user.pbOwnSide.effects[PBEffects::Rainbow] > 0
      #-------------------------------------------------------------------------
      bonus += (base / 2.0) * numHits if numHits > 1
      if b.fainted?
        bonus += Settings::FOCUS_METER_SIZE
      elsif b.damageState.substitute
        bonus /= 2.0
      elsif b.damageState.protected || b.damageState.unaffected
        bonus /= 4.0
      end
      total += bonus
    end
    total /= targets.length if targets.length > 1
    if user.effects[PBEffects::FocusEnergy] > 0
      total *= user.effects[PBEffects::FocusEnergy]
    end
    total /= 2.0 if user.effects[PBEffects::DampenFocus]
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    user.update_focus_meter(total)
  end
  
  def pbRageMeterOpp(attacker, target, move, numHits)
    return if target.focus_meter_full?
    return if target.effects[PBEffects::FocusLock] > 0
    return if @battle.pbAllFainted?(target.idxOpposingSide)
    return if !target.opposes?(attacker) || target.fainted?
    return if target.damageState.missed || target.damageState.unaffected || target.damageState.protected
    base = Settings::FOCUS_METER_SIZE / 20.0
    #---------------------------------------------------------------------------
    # Evasion and Passive modifiers.
    #---------------------------------------------------------------------------
    total = base
    modifiers = {}
    modifiers[:base_accuracy]       = 0
    modifiers[:accuracy_stage]      = attacker.stages[:ACCURACY]
    modifiers[:evasion_stage]       = target.stages[:EVASION]
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    move.pbCalcAccuracyModifiers(attacker, target, modifiers)
    total += [0, base * (modifiers[:evasion_stage] - modifiers[:accuracy_stage])].max
    if move.physicalMove?
      total += (base * target.stages[:DEFENSE]) / 2.0 if target.stages[:DEFENSE] > 0
      total += base if target.pbOwnSide.effects[PBEffects::Reflect] > 0 || target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
    elsif move.specialMove?
      total += (base * target.stages[:SPECIAL_DEFENSE]) / 2.0 if target.stages[:SPECIAL_DEFENSE] > 0
      total += base if target.pbOwnSide.effects[PBEffects::LightScreen] > 0 || target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
    end
    total += base if target.status != :NONE
    total += base if !target.movedThisRound? && target.effects[PBEffects::Flinch]
    total += base if target.hasActiveItem?([:BRIGHTPOWDER, :LAXINCENSE])
    total *= 1.3 if target.damageState.protected || target.damageState.substitute || target.hp <= target.totalhp / 2
    total *= 1.5 if attacker.hasFocusedShot? || attacker.hasFocusedEffect? || attacker.hasFocusedStrike?
    total *= modifiers[:evasion_multiplier]
    #---------------------------------------------------------------------------
    total += (base / 2.0) * numHits if numHits > 1
    if target.effects[PBEffects::FocusEnergy] > 0
      total *= target.effects[PBEffects::FocusEnergy]
    end
    if target.effects[PBEffects::Foresight]  || 
       target.effects[PBEffects::MiracleEye] || 
       target.effects[PBEffects::DampenFocus]
      total /= 2.0
    end
    total *= Settings::FOCUS_GAIN_SCALE
    total = (total.round < 1) ? 1 : total.round
    target.update_focus_meter(total)
  end
end