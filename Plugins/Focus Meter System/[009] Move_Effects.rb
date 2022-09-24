#===============================================================================
# Lock-On, Mind Reader
#===============================================================================
class Battle::Move::EnsureNextMoveAlwaysHits < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.focus_meter_full? || user.effects[PBEffects::FocusLock] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
  
  def pbEffectGeneral(user)
    user.shift_focus(:Accuracy)
    if user.effects[PBEffects::FullyFocused] == 0
      user.effects[PBEffects::FullyFocused] += 2
      @battle.pbDisplay(_INTL("{1} took aim and became fully focused!", user.pbThis))
    end
  end
end

#===============================================================================
# Laser Focus
#===============================================================================
class Battle::Move::EnsureNextCriticalHit < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.focus_meter_full? || user.effects[PBEffects::FocusLock] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
  
  def pbEffectGeneral(user)
    user.shift_focus(:Critical)
    if user.effects[PBEffects::FullyFocused] == 0
      user.effects[PBEffects::FullyFocused] += 2
      @battle.pbDisplay(_INTL("{1} concentrated and became fully focused!", user.pbThis))
    end
  end
end

#===============================================================================
# Focus Punch
#===============================================================================
class Battle::Move::FailsIfUserDamagedThisTurn < Battle::Move
  def pbDisplayChargeMessage(user)
    user.effects[PBEffects::FocusPunch] = true
    @battle.pbCommonAnimation("FocusPunch", user)
    @battle.pbDisplay(_INTL("{1} is tightening its focus!", user.pbThis))
    user.update_focus_meter(Settings::FOCUS_METER_SIZE)
  end

  def pbMoveFailed?(user,targets)
    if user.effects[PBEffects::FocusPunch] && user.lastHPLost > 0
      @battle.pbDisplay(_INTL("{1} lost its focus and couldn't move!", user.pbThis))
      user.reset_focus_meter
      return true
    end
    return false
  end
end