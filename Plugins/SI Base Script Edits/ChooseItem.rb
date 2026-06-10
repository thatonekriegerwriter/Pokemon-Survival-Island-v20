def pbChooseItem(var = 0, *args, &block)
  ret = nil
  pbFadeOutIn {
    scene = PokemonBag_Scene.new
    screen = PokemonBagScreen.new(scene, $bag)
    ret = screen.pbChooseItemScreen(block)
  }
  $game_variables[var] = ret || :NONE if var > 0
  return ret
end

def pbChooseApricorn(var = 0)
  ret = pbChooseItem(var) { |item| GameData::Item.get(item).is_apricorn? }
  return ret
end

def pbChooseFossil(var = 0)
  ret = pbChooseItem(var) { |item| GameData::Item.get(item).is_fossil? }
  return ret
end

def pbChooseBerry(var = 0)
  ret = pbChooseItem(var) { |item| GameData::Item.get(item).is_berry? }
  return ret
end

def pbChooseEdiable(var = 0)
  ret = pbChooseItem(var) { |item| (GameData::Item.get(item).is_foodwater? || GameData::Item.get(item).is_berry?) && !GameData::Item.get(item).is_apricorn? && item!=:ACORN }
  return ret
end


def pbChooseMulch(var = 0)
  ret = pbChooseItem(var) { |item| GameData::Item.get(item).is_mulch? }
  return ret
end


def pbChooseHold(var = 0)
  ret = pbChooseItem(var) { |item| GameData::Item.get(item).can_hold? }
  return ret
end
