module ItemHandlers
  attr_reader :hash
  UseFromBox          = ItemHandlerHash.new
  UseFromEvent          = ItemHandlerHash.new



  def self.hasUseText(item)
    return !UseText[item].nil?
  end

  def self.hasOutHandler(item)                       # Shows "Use" option in Bag
    return !UseFromBag[item].nil? || !UseInField[item].nil? || !UseOnPokemon[item].nil?
  end

  def self.hasUseInFieldHandler(item)           # Shows "Register" option in Bag
    return !UseInField[item].nil?
  end

  def self.hasUseOnPokemon(item)
    return !UseOnPokemon[item].nil?
  end

  def self.hasUseOnPokemonMaximum(item)
    return !UseOnPokemonMaximum[item].nil?
  end

  def self.hasUseInBattle(item)
    return !UseInBattle[item].nil?
  end

  def self.hasBattleUseOnBattler(item)
    return !BattleUseOnBattler[item].nil?
  end

  def self.hasBattleUseOnPokemon(item)
    return !BattleUseOnPokemon[item].nil?
  end

  # Returns text to display instead of "Use"
  def self.getUseText(item)
    return UseText.trigger(item)
  end

  # Return value:
  # 0 - Item not used
  # 1 - Item used, don't end screen
  # 2 - Item used, end screen
  def self.triggerUseFromBag(item)
    ret = 0
    ret = UseFromBag.trigger(item) if UseFromBag[item]
    # No UseFromBag handler exists; check the UseInField handler if present
    if UseInField[item]
      ret = (UseInField.trigger(item)) ? 1 : 0
    end
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==1 && !UseInField[item]
    return ret
  end

  # Returns whether item can be used
  def self.triggerConfirmUseInField(item)
    return true if !ConfirmUseInField[item]
    return ConfirmUseInField.trigger(item)
  end

  # Return value:
  # -1 - Item effect not found
  # 0  - Item not used
  # 1  - Item used
  def self.triggerUseInField(item)
    ret = -1 if !UseInField[item]
    ret = (UseInField.trigger(item)) ? 1 : 0
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==1
    return ret
  end

  # Returns whether item was used
  def self.triggerUseOnPokemon(item, qty, pkmn, scene)
    return false if !UseOnPokemon[item] && !UseOnPokemon[item.id]
    ret = UseOnPokemon.trigger(item, qty, pkmn, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns the maximum number of the item that can be used on the Pokémon at once.
  def self.triggerUseOnPokemonMaximum(item, pkmn)
    return 1 if !UseOnPokemonMaximum[item]
    return 1 if !Settings::USE_MULTIPLE_STAT_ITEMS_AT_ONCE
    return [UseOnPokemonMaximum.trigger(item, pkmn), 1].max
  end

  def self.triggerCanUseInBattle(item, pkmn, battler, move, firstAction, battle, scene, showMessages = true)
    ret = false
    ret = true if !CanUseInBattle[item]   # Can use the item by default
    ret = CanUseInBattle.trigger(item, pkmn, battler, move, firstAction, battle, scene, showMessages)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret 
  end

  def self.CanUseFromEvent?(item, *args)
    return false if $game_temp.assigning?
    return false if $game_temp.current_pkmn_controlled != false
    return false if $game_temp.position_calling == true
	return true 
  end 
  def self.triggerUseInBattle(item, battler, battle)
    ret = UseInBattle.trigger(item, battler, battle)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns whether item was used
  def self.triggerBattleUseOnBattler(item, battler, scene)
    return false if !BattleUseOnBattler[item]
    pbEatingPkmn(pkmn,item) if item.data.is_berry? || item.data.is_foodwater?
    ret = BattleUseOnBattler.trigger(item, battler, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end

  # Returns whether item was used
  def self.triggerBattleUseOnPokemon(item, pkmn, battler, choices, scene)
    return false if !BattleUseOnPokemon[item]
    ret = BattleUseOnPokemon.trigger(item, pkmn, battler, choices, scene)
    pbEatingPkmn(pkmn,item) if (item.data.is_berry? || item.data.is_foodwater?) && ret==true
    return ret
  end


  def self.hasUseFromBox(item)
    return !UseFromBox[item].nil?
  end

  def self.hasUseFromEvent(item)
    return !UseFromEvent[item].nil?
  end
  
  def self.triggerUseFromBox(item, event=nil)
	  return if item.nil?
    return UseFromBox.triggerpokemon(item, event) if item.is_a? Pokemon
    return UseFromBox.trigger(item, event) if UseFromBox[item]
    if UseInField[item]
      return (UseInField.trigger(item)) ? 1 : 0
    end
    if UseFromBag[item]
      return (UseFromBag.trigger(item)) ? 1 : 0
    end
    return 0
  end

  def self.triggerUseFromEvent(item, *args)
    return 0 unless self.CanUseFromEvent?(item, *args)
    item = ItemStorageHelper.get_item_data(item) if item.is_a?(Symbol)
    return UseFromEvent.trigger(item, *args) if UseFromEvent[item]
    return 0
  end
end


class HandlerHash2

  def trigger(sym, *args)
    handler = self[sym.id] if sym.respond_to?("id") 
    return handler&.call(sym, *args)
  end
  def triggerpokemon(sym, *args)
    handler = self[sym]
    return handler&.call(sym, *args)
  end
  
  def [](sym)
    return @hash[sym.id] if sym && sym.respond_to?("id")  && @hash[sym.id]
    return @hash[sym] if sym && !sym.respond_to?("id") && @hash[sym]
    @add_ifs.each do |add_if|
      return add_if[1] if add_if[0].call(sym)
    end
    return nil
  end
  
  def add(sym, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "#{self.class.name} for #{sym.inspect} has no valid handler (#{handler.inspect} was given)"
    end
    @hash[sym] = handler || handlerBlock if sym
  end

  def addIf(conditionProc, handler = nil, &handlerBlock)
    if ![Proc, Hash].include?(handler.class) && !block_given?
      raise ArgumentError, "addIf call for #{self.class.name} has no valid handler (#{handler.inspect} was given)"
    end
    @add_ifs.push([conditionProc, handler || handlerBlock])
  end


end

ItemHandlers::UseFromEvent.add(:PETBEDOUTDOOR, proc { |item, key_id|

localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(PetBedData)
localMeter=PetBedData.new(key_id)
item.internal_data=localMeter
end
if localMeter.reserved_for_egg
 sideDisplay(_INTL("You have a feeling you should leave this bed alone."))
 next 
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT) && localMeter.pokemon.nil?
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:PETBED, proc { |item, key_id|

localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(PetBedData)
localMeter=PetBedData.new(key_id)
item.internal_data=localMeter
end
if localMeter.reserved_for_egg
 sideDisplay(_INTL("You have a feeling you should leave this bed alone."))
 next 
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT) && localMeter.pokemon.nil?
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:BERRYPOT, proc { |item, key_id|

berryPot = item.internal_data


if berryPot.nil? || !berryPot.is_a?(BerryPotData)
berryPot=BerryPotData.new(key_id)
item.internal_data=berryPot
end
berryPot.event_id = key_id if berryPot.event_id!=key_id
if Input.press?(Input::SHIFT)
 if berryPot.planted?
  sideDisplay(_INTL("A Berry is planted there!"))
 else
  Placeable.pick_up(key_id,item)
 end 
else
 pbBerryPot(berryPot)
end
}
)

ItemHandlers::UseFromEvent.add(:CRAFTINGBENCH, proc { |item, key_id|

localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:UPGRADEDCRAFTINGBENCH, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:APRICORNCRAFTING, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:FURNACE, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:GRAVE, proc { |item, key_id|
localMeter = item.internal_data
current_selection = $PokemonGlobal.ball_order[$PokemonGlobal.ball_hud_index]
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id

if Input.press?(Input::SHIFT) && localMeter.result_slot.nil?
  Placeable.pick_up(key_id,item)
elsif current_selection.is_a?(ItemData) && current_selection.id == :SHOVEL && localMeter.result_slot
 pbCraftingBench(item.id, localMeter)
 current_selection.decrease_durability(1)
elsif localMeter.result_slot.nil?
 pbCraftingBench(item.id, localMeter)
elsif localMeter.result_slot
 pkmn = localMeter.result_slot
 sideDisplay(_INTL("{1} is buried here.", pkmn.name))
end

}
)


ItemHandlers::UseFromEvent.add(:CAULDRON, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:SILKSPINNER, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
  localMeter.collect_silk
end
}
)

ItemHandlers::UseFromEvent.add(:GRINDER, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:MEDICINEPOT, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)
ItemHandlers::UseFromEvent.add(:WARDINGTOTEM, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)
ItemHandlers::UseFromEvent.add(:BUTCHERTABLE, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)
ItemHandlers::UseFromEvent.add(:GARBAGEBIN, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)
ItemHandlers::UseFromEvent.add(:COMPOSTER, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:APIARY, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(BeehiveData)
localMeter=BeehiveData.new(key_id, true)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end
}
)

ItemHandlers::UseFromEvent.add(:TORCH, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
end
}
)


ItemHandlers::UseFromEvent.add(:BEDROLL, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pbErasePokemonCenter($game_map.map_id)
Placeable.pick_up(key_id,item)
else
pbBedCore(item)
end
}
)

ItemHandlers::UseFromEvent.add(:PORTABLECAMP, proc { |item, key_id|
if Input.press?(Input::SHIFT)
pbErasePokemonCenter(398)
Placeable.pick_up(key_id,item)
else
pbMessage(_INTL("It's a Campsite Tent."))
end
}
)

ItemHandlers::UseFromEvent.add(:RESEARCHTABLE, proc { |item, key_id|
data = item.internal_data
if data.nil? || !data.is_a?(ResearchTableData)
data=ResearchTableData.new(key_id)
item.internal_data=data
end
data.event_id = key_id if data.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else 
 pbResearchTable(item.id, data)
end
}
)


ItemHandlers::UseFromEvent.add(:ADVENTUREFLAG, proc { |item, key_id|
localMeter = item.internal_data
if localMeter.nil? || !localMeter.is_a?(CraftingStationData)
localMeter=CraftingStationData.new(key_id)
item.internal_data=localMeter
end
localMeter.event_id = key_id if localMeter.event_id!=key_id
if Input.press?(Input::SHIFT)
  Placeable.pick_up(key_id,item)
else
 pbCraftingBench(item.id, localMeter)
end 
#if Input.press?(Input::SHIFT)
#  Placeable.pick_up(key_id,item)
#  next
#end
#pbStartAdventureMenu
}
)


