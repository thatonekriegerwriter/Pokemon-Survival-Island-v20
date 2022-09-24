#===============================================================================
# Various aliases and additions to the Battle::Battler class.
#===============================================================================
class Battle::Battler
  #-----------------------------------------------------------------------------
  # Shifts focus style whenever Accuracy/Evasion stats are raised.
  #-----------------------------------------------------------------------------
  alias focus_pbRaiseStatStageBasic pbRaiseStatStageBasic
  def pbRaiseStatStageBasic(*args)
    ret = focus_pbRaiseStatStageBasic(*args)
    if ret > 0
      gain = (Settings::FOCUS_METER_SIZE / 6).round
      case args[0]
      when :ACCURACY
        shift_focus(:Accuracy)
        update_focus_meter(gain)
      when :EVASION
        shift_focus(:Evasion)
        update_focus_meter(gain)
      end
    end
    return ret
  end
  
  #-----------------------------------------------------------------------------
  # Shifts focus style whenever Accuracy/Evasion stats are lowered.
  # The effects of Focused Guard protects Pokemon from having their style
  # forcibly changed.
  #-----------------------------------------------------------------------------
  alias focus_pbLowerStatStageBasic pbLowerStatStageBasic
  def pbLowerStatStageBasic(*args)
    ret = focus_pbLowerStatStageBasic(*args)
    if ret > 0 && pbOwnSide.effects[PBEffects::FocusedGuard] == 0
      reduce = -(Settings::FOCUS_METER_SIZE / 6).round
      case args[0]
      when :ACCURACY
        shift_focus(:Accuracy)
        update_focus_meter(reduce) 
      when :EVASION
        shift_focus(:Evasion)
        update_focus_meter(reduce)
      end
    end
    return ret
  end
  
  #-----------------------------------------------------------------------------
  # Statuses cannot be inflicted while under the effects of Focused Guard.
  #-----------------------------------------------------------------------------
  alias focus_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(*args)
    ret = focus_pbCanInflictStatus?(*args)
    selfInflicted = (args[1] && args[1].index == @index)
    if pbOwnSide.effects[PBEffects::FocusedGuard] > 0 && !selfInflicted && args[3]
      guard = GameData::Focus.get(:Passive).focus
      @battle.pbDisplay(_INTL("{1}'s team is protected by the effects of {2}!", pbThis, guard)) if args[2]
      ret = false
    end
    return ret
  end
  
  alias focus_pbCanSynchronizeStatus? pbCanSynchronizeStatus?
  def pbCanSynchronizeStatus?
    ret = focus_pbCanSynchronizeStatus?
    ret = false if pbOwnSide.effects[PBEffects::FocusedGuard] > 0
    return ret
  end
  
  #-----------------------------------------------------------------------------
  # Moves cannot be redirected when using a Focused Shot.
  #-----------------------------------------------------------------------------
  alias focus_pbChangeTargets pbChangeTargets
  def pbChangeTargets(move, user, targets)
    return targets if user.hasFocusedShot?
    focus_pbChangeTargets(move, user, targets)
  end
  
  alias focus_pbAddTarget pbAddTarget
  def pbAddTarget(*args)
    return false if !args[2] || (args[2].fainted? && !args[1].hasFocusedShot?)
    focus_pbAddTarget(*args)
  end
  
  #-----------------------------------------------------------------------------
  # Checks for extra effects added by items/Abilities, or move exceptions that 
  # are allowed to be used by Focused Effect.
  #-----------------------------------------------------------------------------
  def hasAddedEffect?(move)
    return true if hasActiveItem?(:QUICKCLAW) || hasActiveAbility?(:QUICKDRAW)
    return true if move.damagingMove? && hasActiveAbility?(:STENCH)
    return true if move.damagingMove? && hasActiveItem?([:KINGSROCK, :RAZORFANG])
    return true if move.contactMove? && hasActiveAbility?(:POISONTOUCH)
    # These moves are singled out due to their effect chance being programmed differently.
    return true if [:ICEFANG, :FIREFANG, :THUNDERFANG].include?(move.id)
    return true if ![0, 100].include?(move.addlEffect)
    return false
  end
  
  #-----------------------------------------------------------------------------
  # Doesn't use up the user's focus if they couldn't act this turn.
  # Only applies to Focused Shot, Focused Strike, and Focused Effect.
  #-----------------------------------------------------------------------------
  alias focus_pbTryUseMove pbTryUseMove
  def pbTryUseMove(*args)
    ret = focus_pbTryUseMove(*args)
    return ret if hasFocusedRage? # Enraged style always triggers, so it doesn't need this check.
    if hasFocusedShot? || hasFocusedStrike? || hasFocusedEffect?
      @focus_trigger = ret
    end
    return ret
  end
  
  #-----------------------------------------------------------------------------
  # Builds focus meter for the appropriate battlers after a move has been used.
  # Also processes specific Focus-related scenarios.
  #-----------------------------------------------------------------------------
  alias focus_pbEffectsAfterMove pbEffectsAfterMove
  def pbEffectsAfterMove(user, targets, move, numHits)
    if move.damagingMove?
      # Focused Dodge increases Evasion after a successful dodge.
      targets.each do |b|
        next if !b || b.fainted? || !b.opposes?(user)
        next if !(b.hasFocusedDodge? && b.damageState.missed)
        if b.pbCanRaiseStatStage?(:EVASION, b, nil, false, true)
          @battle.pbDisplay(_INTL("{1} became more elusive due to dodging {2}'s attack!", b.pbThis, user.pbThis(true)))
          b.pbRaiseStatStage(:EVASION, 1, b, true, true)
        end
      end
      case user.pbOpposingSide.effects[PBEffects::FocusedGuard]
      when 0
        targets.each do |b|
          next if !user.hasFocusedShot? && !user.hasFocusedEffect?
          next if !b || b.fainted? || !b.opposes?(user)
          next if PluginManager.installed?("ZUD Mechanics") && b.effects[PBEffects::RaidShield] > 0
          next if b.damageState.protected  || b.damageState.missed || 
                  b.damageState.unaffected || b.damageState.substitute
          # Focused Shot staggers targets and prevents them from building or using Focus for a number of turns.
          if user.hasFocusedShot?
            @battle.pbDisplay(_INTL("{1} was staggered due to {2}'s direct hit!", b.pbThis, user.pbThis(true)))
            reduce = -(Settings::FOCUS_METER_SIZE / 4).round
            b.update_focus_meter(reduce)
            if b.effects[PBEffects::FocusLock] == 0
              b.effects[PBEffects::FocusLock] = 4
              @battle.pbDisplay(_INTL("{1} briefly lost its ability to focus!", b.pbThis))
            end
          end
          # Focused Effect deals a lingering potent strike on targets that impairs the amount of focus gained.
          if user.hasFocusedEffect?
            if !b.effects[PBEffects::DampenFocus]
              @battle.pbDisplay(_INTL("{1}'s focus was impaired due to {2}'s potent attack!", b.pbThis, user.pbThis(true)))
              b.effects[PBEffects::DampenFocus] = true
            end
          end
          b.pbItemStatusCureCheck
        end
      else
        targets.each do |b|
          next if !user.hasFocusedStrike?
          next if !b || b.fainted? || !b.opposes?(user)
          next if PluginManager.installed?("ZUD Mechanics") && b.effects[PBEffects::RaidShield] > 0
          next if b.damageState.protected  || b.damageState.missed || b.damageState.unaffected
          # Focused Strike removes the opposing team's Focused Guard.
          guard = GameData::Focus.get(:Passive).focus
          user.pbOpposingSide.effects[PBEffects::FocusedGuard] = 0
          @battle.pbDisplay(_INTL("{1}'s {2} was broken!", user.pbOpposingTeam, guard))
          break
        end
      end
    end
    pbBuildFocus(user, targets, move, numHits)
    focus_pbEffectsAfterMove(user, targets, move, numHits)
  end
end