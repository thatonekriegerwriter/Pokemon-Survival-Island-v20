#===============================================================================
# Items with updated calculations.
#===============================================================================
Battle::ItemEffects::AccuracyCalcFromUser.add(:WIDELENS,
  proc { |item, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.5
  }
)

Battle::ItemEffects::AccuracyCalcFromUser.add(:ZOOMLENS,
  proc { |item, mods, user, target, move, type|
    if (target.battle.choices[target.index][0] != :UseMove &&
       target.battle.choices[target.index][0] != :Shift) ||
       target.movedThisRound?
      mods[:accuracy_multiplier] *= 2.0
    end
  }
)

Battle::ItemEffects::AccuracyCalcFromTarget.add(:BRIGHTPOWDER,
  proc { |item, mods, user, target, move, type|
    mods[:accuracy_multiplier] /= 2.0
  }
)
Battle::ItemEffects::AccuracyCalcFromTarget.copy(:BRIGHTPOWDER, :LAXINCENSE)


Battle::ItemEffects::CriticalCalcFromUser.add(:RAZORCLAW,
  proc { |item, user, target, c|
    next c *= 1.75
  }
)
Battle::ItemEffects::CriticalCalcFromUser.copy(:RAZORCLAW, :SCOPELENS)

#===============================================================================
# Quick Claw may now only trigger as part of a Focused Effect.
#===============================================================================
Battle::ItemEffects::PriorityBracketChange.add(:QUICKCLAW,
  proc { |item, battler, battle|
    next 1 if battler.hasFocusedEffect?
  }
)

#===============================================================================
# Micle Berry now fully charges the user's focus meter in a pinch.
#===============================================================================
Battle::ItemEffects::HPHeal.add(:MICLEBERRY,
  proc { |item, battler, battle, forced|
    next false if !forced && !battler.canConsumePinchBerry?
    next false if battler.focus_meter_full? || battler.effects[PBEffects::FocusLock] > 0
    battle.pbCommonAnimation("EatBerry", battler) if !forced
    startMeter = battler.focus_meter
    battler.focus_meter = Settings::FOCUS_METER_SIZE
    rangeMeter = battler.focus_meter - startMeter
    battle.scene.pbFillFocusMeter(battler, startMeter, battler.focus_meter, rangeMeter)
    itemName = GameData::Item.get(item).name
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1} became intensely focused!",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} became intensely focused using its {2}!",
         battler.pbThis,itemName))
    end
    next true
  }
)

#===============================================================================
# Mental Herb now also cures effects that impair the user's focus.
#===============================================================================
Battle::ItemEffects::StatusCure.add(:MENTALHERB,
  proc { |item, battler, battle, forced|
    next false if battler.effects[PBEffects::Attract]   == -1 &&
                  battler.effects[PBEffects::Taunt]     == 0  &&
                  battler.effects[PBEffects::Encore]    == 0  &&
                  !battler.effects[PBEffects::Torment]        &&
                  battler.effects[PBEffects::Disable]   == 0  &&
                  battler.effects[PBEffects::HealBlock] == 0  &&
                  battler.effects[PBEffects::FocusLock] == 0  &&
                  !battler.effects[PBEffects::DampenFocus]
    itemName = GameData::Item.get(item).name
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}")
    battle.pbCommonAnimation("UseItem", battler) if !forced
    if battler.effects[PBEffects::Attract] >= 0
      if forced
        battle.pbDisplay(_INTL("{1} got over its infatuation due to its {1}.", battler.pbThis, itemName))
      else
        battle.pbDisplay(_INTL("{1} cured its infatuation status using its {2}!", battler.pbThis, itemName))
      end
      battler.pbCureAttract
    end
    battle.pbDisplay(_INTL("{1}'s taunt wore off due to its {1}!", battler.pbThis, itemName)) if battler.effects[PBEffects::Taunt] > 0
    battler.effects[PBEffects::Taunt] = 0
    battle.pbDisplay(_INTL("{1}'s encore ended due to its {1}!", battler.pbThis, itemName)) if battler.effects[PBEffects::Encore] > 0
    battler.effects[PBEffects::Encore]     = 0
    battler.effects[PBEffects::EncoreMove] = nil
    battle.pbDisplay(_INTL("{1}'s torment wore off due to its {1}!", battler.pbThis, itemName)) if battler.effects[PBEffects::Torment]
    battler.effects[PBEffects::Torment] = false
    battle.pbDisplay(_INTL("{1} is no longer disabled due to its {1}!", battler.pbThis, itemName)) if battler.effects[PBEffects::Disable] > 0
    battler.effects[PBEffects::Disable] = 0
    battle.pbDisplay(_INTL("{1}'s Heal Block wore off due to its {1}!", battler.pbThis, itemName)) if battler.effects[PBEffects::HealBlock] > 0
    battler.effects[PBEffects::HealBlock] = 0
    battle.pbDisplay(_INTL("{1} regained its focus due to its {1}!",battler.pbThis, itemName)) if battler.effects[PBEffects::FocusLock] > 0
    battler.effects[PBEffects::FocusLock]  = 0
    battle.pbDisplay(_INTL("{1}'s focus is no longer impaired due to its {1}!",battler.pbThis, itemName)) if battler.effects[PBEffects::DampenFocus]
    battler.effects[PBEffects::DampenFocus] = false
    next true
  }
)

#===============================================================================
# Dire Hit is completely changed to support the Critical Hit Focus Style.
#===============================================================================
ItemHandlers::CanUseInBattle.add(:DIREHIT,proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if !battler || battler.effects[PBEffects::CriticalBoost] >= 6
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
})

ItemHandlers::CanUseInBattle.copy(:DIREHIT, :DIREHIT2, :DIREHIT3, :DIREHIT6)

ItemHandlers::BattleUseOnBattler.add(:DIREHIT, proc { |item, battler, scene|
  battler.shift_focus(:Critical)
  case item
  when :DIREHIT  then increment = 1
  when :DIREHIT2 then increment = 2
  when :DIREHIT3 then increment = 3
  when :DIREHIT6 then increment = 6
  end
  increment = [increment, 6 - battler.effects[PBEffects::CriticalBoost]].min
  battler.effects[PBEffects::CriticalBoost] = increment
  scene.pbCommonAnimation("StatUp", battler)
  arrStatTexts = [
     _INTL("{1}'s critical hit rate rose!", battler.pbThis),
     _INTL("{1}'s critical hit rate rose sharply!", battler.pbThis),
     _INTL("{1}'s critical hit rate rose drastically!", battler.pbThis)]
  scene.pbDisplay(arrStatTexts[[increment - 1, 2].min])
  battler.pokemon.changeHappiness("battleitem")
})

ItemHandlers::BattleUseOnBattler.copy(:DIREHIT, :DIREHIT2, :DIREHIT3, :DIREHIT6)