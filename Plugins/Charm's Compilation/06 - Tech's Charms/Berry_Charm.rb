#===============================================================================
# * Berry Charm
#===============================================================================

def pbPickBerry(berry, qty = 1)
  qty *= 2 if $player.activeCharm?(:BERRYCHARM)
  berry = GameData::Item.get(berry)
  berry_name = (qty > 1) ? berry.name_plural : berry.name
  if qty > 1
    message = _INTL("There are {1} \\c[1]{2}\\c[0]!\nWant to pick them?", qty, berry_name)
  else
    message = _INTL("There is 1 \\c[1]{1}\\c[0]!\nWant to pick it?", berry_name)
  end
  return false if !pbConfirmMessage(message)
  if !$bag.can_add?(berry, qty)
    pbMessage(_INTL("Too bad...\nThe Bag is full..."))
    return false
  end
  $stats.berry_plants_picked += 1
  if qty >= GameData::BerryPlant.get(berry.id).maximum_yield
    $stats.max_yield_berry_plants += 1
  end
  $bag.add(berry, qty)
  if qty > 1
    pbMessage(_INTL("\\me[Berry get]You picked the {1} \\c[1]{2}\\c[0].\\wtnp[30]", qty, berry_name))
  else
    pbMessage(_INTL("\\me[Berry get]You picked the \\c[1]{1}\\c[0].\\wtnp[30]", berry_name))
  end
  pocket = berry.pocket
  pbMessage(_INTL("{1} put the \\c[1]{2}\\c[0] in the <icon=bagPocket{3}>\\c[1]{4}\\c[0] Pocket.\1",
                  $player.name, berry_name, pocket, PokemonBag.pocket_names[pocket - 1]))
  if Settings::NEW_BERRY_PLANTS
    pbMessage(_INTL("The soil returned to its soft and earthy state."))
  else
    pbMessage(_INTL("The soil returned to its soft and loamy state."))
  end
  this_event = pbMapInterpreter.get_self
  pbSetSelfSwitch(this_event.id, "A", true)
  return true
end