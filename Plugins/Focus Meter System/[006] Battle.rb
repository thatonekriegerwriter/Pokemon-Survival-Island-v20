#===============================================================================
# Core additions to the Battle class.
#===============================================================================
class Battle
  alias focus_initialize initialize
  def initialize(*args)
    focus_initialize(*args)
    @focusMeter = [
       [-1] * (@player ? @player.length : 1),
       [-1] * (@opponent ? @opponent.length : 1)
    ]
  end
  
  #-----------------------------------------------------------------------------
  # Adds focus-related counters to be checked at the end of each round.
  #-----------------------------------------------------------------------------
  alias focus_pbEOREndBattlerEffects pbEOREndBattlerEffects
  def pbEOREndBattlerEffects(priority)
    focus_pbEOREndBattlerEffects(priority)
    priority.each do |b|
      if b.focus_meter_full?
        b.focus_timer -= 1
        if b.focus_trigger
          b.reset_focus_meter
        elsif b.focus_timer == 0
          pbDisplay(_INTL("{1} lost its built up focus!", b.pbThis))
          b.reset_focus_meter
        end
      end
      b.effects[PBEffects::FullyFocused] -= 1 if b.effects[PBEffects::FullyFocused] > 0
    end
    pbEORCountDownBattlerEffect(priority, PBEffects::FocusLock) { |battler|
      pbDisplay(_INTL("{1} regained its ability to focus!", battler.pbThis))
    }
  end
  
  alias focus_pbEOREndSideEffects pbEOREndSideEffects
  def pbEOREndSideEffects(side, priority)
    focus_pbEOREndSideEffects(side, priority)
    pbEORCountDownSideEffect(side, PBEffects::FocusedGuard,
                             _INTL("{1}'s Focused Guard wore off!", @battlers[side].pbTeam))
  end
  
  #-----------------------------------------------------------------------------
  # Eligibility check.
  #-----------------------------------------------------------------------------
  def pbCanUseFocus?(idxBattler)
    battler = @battlers[idxBattler]
    return false if $game_switches[Settings::NO_FOCUS_MECHANIC]
    return false if !battler.focus_meter_full?
    return false if battler.effects[PBEffects::FocusStyle] == :None
    return true if $DEBUG && Input.press?(Input::CTRL)
    return false if battler.effects[PBEffects::FocusLock] > 0
    return false if battler.effects[PBEffects::SkyDrop] >= 0
    side  = battler.idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    return @focusMeter[side][owner] == -1
  end
  
  #-----------------------------------------------------------------------------
  # Triggers focus usage.
  #-----------------------------------------------------------------------------
  def pbUseFocus(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon
    return if !battler.focus_meter_full?
    move = @choices[idxBattler][2]
    return if battler.moveHasExceptionCode?(move)
    style = GameData::Focus.get(battler.effects[PBEffects::FocusStyle])
    triggers = ["focus", "focus" + battler.species.to_s, "focus" + style.id.to_s.upcase]
    battler.pokemon.types.each { |t| triggers.push("focus" + t.to_s) }
    # The focus styles below may always be triggered.
    if style.id == :Enraged
      $stats.enraged_focus_count += 1 if !battler.pbOwnedByPlayer?
      triggers.push("focusBoss") if battler.opposes?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} unleashes its {2}!", battler.pbThis, style.focus))
      pbFocusedRageEffects(idxBattler)
      return
    end
    # These focus styles below can't be triggered if asleep or frozen.
    return if [:SLEEP, :FROZEN].include?(battler.status)
    case style.id
    when :Evasion
      $stats.evasion_focus_count += 1 if battler.pbOwnedByPlayer?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} readies a {2}!", battler.pbThis, style.focus))
      pbAnimation(:TAILWHIP, battler, battler.pbDirectOpposing)
      pbDisplay(_INTL("{1} may evade incoming attacks!", battler.pbThis))
      battler.focus_trigger = true
      return
    when :Passive
      $stats.passive_focus_count += 1 if battler.pbOwnedByPlayer?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} readies a {2}!", battler.pbThis, style.focus))
      pbFocusedGuardEffects(idxBattler)
      return
    end
    # These focus styles below also can't be triggered if struggling, or initiating a two-turn effect.
    target_foe = GameData::Target.get(move.target).targets_foe
    return if move == @struggle
    return if move.pbIsChargingTurn?(battler)
    return if battler.effects[PBEffects::Truant]
    return if battler.effects[PBEffects::HyperBeam] > 0
    case style.id
    when :Accuracy
      return if move.accuracy == 0 || !target_foe
      $stats.accuracy_focus_count += 1 if battler.pbOwnedByPlayer?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} readies a {2}!", battler.pbThis, style.focus))
      pbAnimation(:LOCKON, battler, battler.pbDirectOpposing)
      pbDisplay(_INTL("{1}'s aim may bypass {2}'s evasiveness!", battler.pbThis, battler.pbOpposingTeam(true)))
      battler.focus_trigger = true
    when :Critical
      return if move.statusMove? || !target_foe
      $stats.critical_focus_count += 1 if battler.pbOwnedByPlayer?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} readies a {2}!", battler.pbThis, style.focus))
      pbAnimation(:LEER, battler, battler)
      pbDisplay(_INTL("{1} may pierce through {2}'s defenses!", battler.pbThis, battler.pbOpposingTeam(true)))
      battler.focus_trigger = true
    when :Potency
      return if !battler.hasAddedEffect?(move)
      $stats.potency_focus_count += 1 if battler.pbOwnedByPlayer?
      @scene.pbDeluxeTriggers(idxBattler, nil, triggers)
      pbDisplay(_INTL("{1} readies a {2}!", battler.pbThis, style.focus))
      pbAnimation(:TAILGLOW, battler, battler)
      pbDisplay(_INTL("{1}'s attacks may have additional effects!", battler.pbThis))
      battler.focus_trigger = true # Purposely set first to ensure Quick Claw/Draw proc.
      pbCalculatePriority(true)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Applies focus effects when triggering a Focused Guard.
  #-----------------------------------------------------------------------------
  def pbFocusedGuardEffects(idxBattler)
    battler = @battlers[idxBattler]
    if battler.pbOwnSide.effects[PBEffects::FocusedGuard] == 0
      pbAnimation(:REFLECT, battler, battler)
      pbDisplay(_INTL("A powerful barrier envelops {1}!", battler.pbTeam(true)))
      eachSameSideBattler(idxBattler) do |b|
        if b.effects[PBEffects::FocusLock] > 0
          b.effects[PBEffects::FocusLock] = 0
          pbDisplay(_INTL("{1} regained its focus!", b.pbThis))
        end
        if b.effects[PBEffects::DampenFocus]
          b.effects[PBEffects::DampenFocus] = false
          pbDisplay(_INTL("{1}'s focus is no longer impaired!", b.pbThis))
        end
      end
      battler.pbOwnSide.effects[PBEffects::FocusedGuard] = 4
      battler.focus_trigger = true
    else
      pbDisplay(_INTL("But it failed!"))
    end
  end
    
  #-----------------------------------------------------------------------------
  # Applies focus effects when triggering Focused Rage.
  #-----------------------------------------------------------------------------
  def pbFocusedRageEffects(idxBattler)
    if !pbOwnedByPlayer?(idxBattler)
      battler = @battlers[idxBattler]
      battler.focus_trigger = true
      pbAnimation(:SWAGGER, battler, battler)
      pbFocusedGuardEffects(idxBattler) if battler.pbOwnSide.effects[PBEffects::FocusedGuard] == 0
    else
      pbDisplay(_INTL("But nothing happened..."))
      return
    end
  end

  #-----------------------------------------------------------------------------
  # Registering focus usage.
  #-----------------------------------------------------------------------------
  def pbRegisterFocus(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @focusMeter[side][owner] = idxBattler
  end

  def pbUnregisterFocus(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @focusMeter[side][owner] = -1 if @focusMeter[side][owner] == idxBattler
  end

  def pbToggleRegisteredFocus(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    if @focusMeter[side][owner] == idxBattler
      @focusMeter[side][owner] = -1
    else
      @focusMeter[side][owner] = idxBattler
    end
  end

  def pbRegisteredFocus?(idxBattler)
    side  = @battlers[idxBattler].idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    return @focusMeter[side][owner] == idxBattler
  end
  
  def pbAttackPhaseFocus
    pbPriority.each do |b|
      next unless @choices[b.index][0] == :UseMove && !b.fainted?
      owner = pbGetOwnerIndexFromBattlerIndex(b.index)
      next if @focusMeter[b.idxOwnSide][owner] != b.index
      pbUseFocus(b.index)
    end
  end
end

#===============================================================================
# Core additions to the Battle::AI class.
#===============================================================================
class Battle::AI
  def pbEnemyShouldFocus?(idxBattler)
    battler = @battle.battlers[idxBattler]
    target  = battler.pbDirectOpposing(true)
    if @battle.pbCanUseFocus?(idxBattler)
      return true if battler.focus_timer == 1
      case battler.effects[PBEffects::FocusStyle]
      when :Accuracy
        return false if battler.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
        return false if target.effects[PBEffects::Substitute] > 0
        return false if target.effects[PBEffects::FocusLock] > 0
      when :Evasion
        return false if target.inAccuracyStyle? && target.focus_meter_full?
      when :Critical
        return false if battler.pbOpposingSide.effects[PBEffects::LuckyChant] > 0
        return false if target.hasActiveAbility?([:BATTLEARMOR, :SHELLARMOR, :ANGERPOINT])
        return false if target.effects[PBEffects::Substitute] > 0
        return false if target.inEvasionStyle? && target.focus_meter_full?
      when :Potency
        return false if battler.pbOpposingSide.effects[PBEffects::FocusedGuard] > 0
        return false if target.hasActiveAbility?(:SHIELDDUST)
        return false if target.effects[PBEffects::Substitute] > 0
      when :Passive
        return false if battler.pbOwnSide.effects[PBEffects::FocusedGuard] > 0
      end
      PBDebug.log("[AI] #{battler.pbThis} (#{idxBattler}) will harness its focus")
      return true
    end
    return false
  end
end