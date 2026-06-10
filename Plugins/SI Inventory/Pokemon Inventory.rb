class Pokemon
  attr_reader   :inventory


  alias _SI_Inv_Pokemon_init initialize
  def initialize(*args)
    _SI_Inv_Pokemon_init(*args)
    @inventory     = PokemonItems.new

  end 

  def inventory
    @inventory  = PokemonItems.new if @inventory.is_a?(Array) || !@inventory.is_a?(PokemonItems) || @inventory.nil?
    return @inventory
  end 

  def item
    return self.inventory.item
  end

  def item_id
    return self.inventory.item.id
  end
  
  def item=(value)
    raise "Item= has been used for niling!" if value.nil?
    return if value && !GameData::Item.exists?(value)
	return if !value
    self.inventory.item = value.is_a?(Symbol) ? ItemData.new(value) : value
  end
  
  def hasItem?(check_item = nil)
    return !self.inventory.full? if check_item.nil?
    inventory = self.inventory
    return inventory.has?(check_item)
  end


end 


class PokemonItems
  MAX_ITEMS = 3

  def initialize
    @items = Array.new(MAX_ITEMS, nil)
  end 
  

  def [](index)
    @items[index]
  end 

  def []=(index, item, amt)
    return false if index < 0 || index >= MAX_ITEMS
    @items[index] = [item, amt]
  end 
  
  def item
    return @items[0][0]
  end 
  def item=(value)
    @items[0] = [value,1]
  end 
  
  def quantity(item)
    item_data = GameData::Item.try_get(item)
    return 0 if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.quantity(@items, item_data.id)
  end

  def has?(item, qty = 1)
    return quantity(item) >= qty
  end
  alias can_remove? has?

  def can_add?(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = MAX_ITEMS
    return ItemStorageHelper.can_add?(
      @items, max_size, 3, item_data.id, qty
    )
  end

  def add(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = MAX_ITEMS
    ret = ItemStorageHelper.add(@items, max_size, 3, item_data.id, qty)
    return ret
  end
  def add_all(item, qty = 1)
    return false if !can_add?(item, qty)
    return add(item, qty)
  end
  def remove(item, qty = 1)
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.remove(@items, item_data.id, qty)
  end
  def remove_all(item, qty = 1)
    return false if !can_remove?(item, qty)
    return remove(item, qty)
  end
  def empty?(index)
    @items[index].nil?
  end

  def full?
    @items.none?(&:nil?)
  end
  
end 



GameData::Evolution.register({
  :id                   => :HappinessHoldItem,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && pkmn.happiness >= (Settings::APPLY_HAPPINESS_SOFT_CAP ? 160 : 220)
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)   # Item is now consumed
    next true
  }
})

GameData::Evolution.register({
  :id                   => :HoldItem,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter)
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :HoldItemMale,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && pkmn.male?
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :HoldItemFemale,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && pkmn.female?
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :DayHoldItem,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && PBDayNight.isDay?
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :NightHoldItem,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && PBDayNight.isNight?
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :HoldItemHappiness,
  :parameter            => :Item,
  :minimum_level        => 1,   # Needs any level up
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.inventory.has?(parameter) && pkmn.happiness >= (Settings::APPLY_HAPPINESS_SOFT_CAP ? 160 : 220)
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})

GameData::Evolution.register({
  :id                   => :TradeItem,
  :parameter            => :Item,
  :on_trade_proc        => proc { |pkmn, parameter, other_pkmn|
    next pkmn.inventory.has?(parameter)
  },
  :after_evolution_proc => proc { |pkmn, new_species, parameter, evo_species|
    next false if evo_species != new_species || !pkmn.hasItem?(parameter)
    pkmn.inventory.remove(parameter)
    next true
  }
})