#===============================================================================
# * Twin Charm / Coin Charm if you want to add pbReceiveCoins method to put random coins on the ground
#===============================================================================

def pbItemBall(item, quantity = 1)
  item = GameData::Item.get(item)
  return false if !item || quantity < 1
  event_name = $game_map.events[@event_id].name  # Use the event_id to get the event and its name
  quantity *= 2 if event_name[/hiddenitem/i] && $player.activeCharm?(:TWINCHARM)
  itemname = (quantity > 1) ? item.name_plural : item.name
  pocket = item.pocket
  move = item.move
  if $bag.add(item, quantity)   # If item can be picked up
    meName = (item.is_key_item?) ? "Key item get" : "Item get"
    if item == :LEFTOVERS
      pbMessage(_INTL("\\me[{1}]You found some \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    elsif item == :DNASPLICERS
      pbMessage(_INTL("\\me[{1}]You found \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    elsif item.is_machine?   # TM or HM
      pbMessage(_INTL("\\me[{1}]You found \\c[1]{2} {3}\\c[0]!\\wtnp[30]", meName, itemname, GameData::Move.get(move).name))
    elsif quantity > 1
      pbMessage(_INTL("\\me[{1}]You found {2} \\c[1]{3}\\c[0]!\\wtnp[30]", meName, quantity, itemname))
    elsif itemname.starts_with_vowel?
      pbMessage(_INTL("\\me[{1}]You found an \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    else
      pbMessage(_INTL("\\me[{1}]You found a \\c[1]{2}\\c[0]!\\wtnp[30]", meName, itemname))
    end
    pbMessage(_INTL("You put the {1} in\\nyour Bag's <icon=bagPocket{2}>\\c[1]{3}\\c[0] pocket.",
                    itemname, pocket, PokemonBag.pocket_names[pocket - 1]))
    return true
  end
  # Can't add the item
  if item == :LEFTOVERS
    pbMessage(_INTL("You found some \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  elsif item.is_machine?   # TM or HM
    pbMessage(_INTL("You found \\c[1]{1} {2}\\c[0]!\\wtnp[30]", itemname, GameData::Move.get(move).name))
  elsif quantity > 1
    pbMessage(_INTL("You found {1} \\c[1]{2}\\c[0]!\\wtnp[30]", quantity, itemname))
  elsif itemname.starts_with_vowel?
    pbMessage(_INTL("You found an \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  else
    pbMessage(_INTL("You found a \\c[1]{1}\\c[0]!\\wtnp[30]", itemname))
  end
  pbMessage(_INTL("But your Bag is full..."))
  return false
end

#Finding Coins
def pbReceiveCoins(quantity)
  if $player.activeCharm?(:COINCHARM)
    quantity *= 3
  end
  $player.coins += quantity
  pbMessage("You have received #{quantity} coins!")
end