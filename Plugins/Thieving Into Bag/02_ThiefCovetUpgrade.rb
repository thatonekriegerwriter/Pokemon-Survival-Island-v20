#===============================================================================
# Thief and Covet update.
#===============================================================================
class Battle::Move::UserTakesTargetItem < Battle::Move
  def pbEffectAfterAllHits(user, target)
    return if user.wild?   # Wild Pokémon can't thieve
    return if user.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    return if !target.item || user.item
    return if target.unlosableItem?(target.item)
    return if user.unlosableItem?(target.item)
    return if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    itemName = target.itemName
    user.item = target.item
    # Permanently steal the item from wild Pokémon
    if target.wild? && !user.initialItem && target.item == target.initialItem
      $bag.add(target.item)
      target.pbRemoveItem
    else
      target.pbRemoveItem(false)
    end
    @battle.pbMessage(_INTL("{1} stole {2}'s item <item = {3}> {4} and sent it to {5}'s bag.", user.pbThis, target.pbThis(true), user.item_id, itemName, $Trainer.name, $Trainer.name{4}))
    user.pbHeldItemTriggerCheck
  end.name
end
