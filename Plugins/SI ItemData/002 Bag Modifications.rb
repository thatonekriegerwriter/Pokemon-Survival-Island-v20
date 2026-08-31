

module ItemStorageHelper

  def self.get_item_data(item,durability=false,water=false)
      item_slot = ItemData.new(item,durability,water)
      return item_slot
  end
  def self.convert_to_itemdata(items)
    items.map!.with_index do |item_slot, index|
	  next item_slot if item_slot.is_a? ItemData
      item_slot = [ItemData.new(item_slot[0]),item_slot[1]]
	  
    end
  end
  
  def self.hasflagamt(items)
    ret = 0
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0].id).is_pokeball?
      ret = item_slot[1]
    end
    return ret
  end

  def self.any_pokeballs(items)
    ret = []
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0].id).is_pokeball?
      ret << item_slot[0]
    end
    return ret
  end
  
  

  # Returns the quantity of item in items
  def self.quantity(items, item)
    ret = 0
	item = get_item_data(item) if item.is_a?(Symbol)
    items.each_with_index do |item_slot, index| 
	  next unless item_slot 
	  slot_item, amt = item_slot
	  ret += item_slot[1] if slot_item.identical(item)
	 end
    return ret
  end
  
  def self.quantity_of_sym(items, item)
    ret = 0
    items.each_with_index do |item_slot, index| 
	  ret += item_slot[1] if item_slot && item_slot[0].identical(item)
	 end
    return ret
  end

  def self.can_add?(items, max_slots, max_per_slot, item, qty)
	item = get_item_data(item) if item.is_a?(Symbol)
    raise "Invalid value for qty: #{qty}" if qty < 0
    return true if qty == 0
    max_slots.times do |i|
      item_slot = items[i]
      if !item_slot
        qty -= [qty, max_per_slot].min
        return true if qty == 0
      elsif item_slot[0].identical(item) && item_slot[1] < max_per_slot
        new_amt = item_slot[1]
        new_amt = [new_amt + qty, max_per_slot].min
        qty -= (new_amt - item_slot[1])
        return true if qty == 0
      end
    end
    return false
  end

  def self.add(items, max_slots, max_per_slot, item, qty)
	items = convert_to_itemdata(items) if items.any? { |element| element && element[0].is_a?(Symbol) }
	item = get_item_data(item) if item.is_a?(Symbol)
    raise "Invalid value for qty: #{qty}" if qty < 0
    return true if qty == 0
	return false if !self.can_add?(items, max_slots, max_per_slot, item, qty)
    max_slots.times do |i|
      item_slot = items[i]
      if !item_slot
        items[i] = [item, [qty, max_per_slot].min]
        qty -= items[i][1]
        return true if qty == 0
      elsif item_slot[0].identical(item) && item_slot[1] < max_per_slot
        new_amt = item_slot[1]
        new_amt = [new_amt + qty, max_per_slot].min
        qty -= (new_amt - item_slot[1])
        item_slot[1] = new_amt
        return true if qty == 0
      end
    end
    return false
  end

  
    def self.get_index(items, max_slots, max_per_slot, item, qty)
	item = get_item_data(item) if item.is_a?(Symbol)
    raise "Invalid value for qty: #{qty}" if qty < 0
    return true if qty == 0
    max_slots.times do |i|
      item_slot = items[i]
      if item_slot[0].identical(item)
        return item_slot
      end
    end
    return nil
  end
  
  
  
  # Deletes an item (items array, max. size per slot, item, no. of items to delete)
  def self.remove(items, item, qty)
	item = get_item_data(item) if item.is_a?(Symbol)
	if GameData::Item.get(item).id==:CAPTURESTYLUS && $player.is_it_this_class?(:RANGER)
	 pbMessage(_INTL("You can't throw away a Capture Styler!"))
    return false 
	end
    raise "Invalid value for qty: #{qty}" if qty < 0
    return true if qty == 0
    ret = false
    items.each_with_index do |item_slot, i|
      next if !item_slot || !item_slot[0].identical(item)
      amount = [qty, item_slot[1]].min
      item_slot[1] -= amount
      qty -= amount
      items[i] = nil if item_slot[1] == 0
      next if qty > 0
      ret = true
      break
    end
    items.compact!
    return ret
  end
end


class PokemonBag
   attr_accessor :pocket_size
  alias _SI_Bag_Init initialize
  def initialize
    _SI_Bag_Init
    @pocket_size = Settings::BAG_MAX_POCKET_SIZE.dup
  end
  
  def pocket_size
    @pocket_size = Settings::BAG_MAX_POCKET_SIZE.dup if @pocket_size.nil?
    return @pocket_size
  end
  
  def max_pocket_size(pocket)
    pocket_size if @pocket_size.nil?
    return @pocket_size[pocket - 1] || -1
  end
  
  def isToolinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_tool?  || item.name.to_s.include?("Bottle")
      items << item
	  end
	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end
  def isWeaponinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_weapon? || itm.is_pokeball?
      items << item
	  end
	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end
  
  
  def isBattleIteminInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if (itm.is_berry? && itm.name.include?("Berry")) || itm.is_foodwater? || itm.name.include?("Potion") || itm.id==:REVIVALHERB || itm.is_dart? || itm.id==:HEALPOWDER || itm.id==:ENERGYPOWDER || itm.id==:ENERGYROOT
      items << item
	  end

	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end
  
  
  def isCropIteminInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_berry?
      items << item
	  end

	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end
  def isBaitIteminInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if (itm.is_berry? || itm.is_foodwater? || itm.is_bait?) && !itm.is_apricorn? && itm.id!=:ACORN
      items << item
	  end

	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end

  def isPlacableinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  next if i.nil?
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_placeitem?
      items << item
	  end
	end
	end
	 items = items.uniq { |item| item.id }
    return items
  end
  def amtwithFlag?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.hasflagamt(@pockets[pocket])
  end
  
  def any_pokeballs?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.any_pokeballs(@pockets[pocket])
  end


  def quantity(item, durability = false, water = false)
    item_data = GameData::Item.try_get(item)
    return 0 if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.quantity(@pockets[pocket], item)
  end


  def quantity_sym(item, durability = false, water = false)
    item = GameData::Item.get(item).id if item.is_a? ItemData
    item_data = GameData::Item.try_get(item)
    return 0 if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.quantity_of_sym(@pockets[pocket], item)
  end

  def has?(item, qty = 1, sym=false,durability = false, water = false)
    item = item.id if sym==true && item.is_a?(ItemData)
    return quantity_sym(item, durability, water) >= qty if item.is_a?(Symbol)
    return quantity(item, durability, water) >= qty if item.is_a?(ItemData)
  end
  
  
  alias can_remove? has?

  def can_add?(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
     return if item.durability.is_a?(Numeric) && item.durability <= 0
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    return ItemStorageHelper.can_add?(
      @pockets[pocket], max_size, item.stack_size, item, qty
    )
  end

  def add(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
     return if item.durability.is_a?(Numeric) && item.durability <= 0
    item_data = GameData::Item.try_get(item)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
	
    @pockets[pocket].fill(nil, @pockets[pocket].length...Settings::BAG_MAX_POCKET_SIZE.max) 
    ret = ItemStorageHelper.add(@pockets[pocket],
                                max_size, item.stack_size, item, qty)
    if ret && Settings::BAG_POCKET_AUTO_SORT[pocket - 1]
      @pockets[pocket].sort! { |a, b| GameData::Item.keys.index(a[0]) <=> GameData::Item.keys.index(b[0]) }
    end
    return ret
  end

  # Adds qty number of item. Doesn't add anything if it can't add all of them.
  def add_all(item, qty = 1, durability = false, water = false)
    return false if !can_add?(item, qty, durability, water)
    return add(item, qty, durability, water)
  end

  # Deletes as many of item as possible (up to qty), and returns whether it
  # managed to delete qty of them.
  def remove(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
     return if item.durability.is_a?(Numeric) && item.durability <= 0
    item_data = GameData::Item.try_get(item)
	return true if ($player.is_it_this_class?(:COLLECTOR) && rand(100)<=20)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.remove(@pockets[pocket], item, qty)
  end

  # Deletes qty number of item. Doesn't delete anything if there are less than
  # qty of the item in the Bag.
  def remove_all(item, qty = 1, durability = false, water = false)
    return false if !can_remove?(item, qty, durability, water)
    return remove(item, qty, durability, water)
  end

  # This only works if the old and new items are in the same pocket. Used for
  # switching on/off certain Key Items. Replaces all old_item in its pocket with
  # new_item.
  def replace_item(old_item, new_item)
    old_id = GameData::Item.get(item).id if !old_item.is_a? ItemData
	 old_item = ItemStorageHelper.get_item_data(old_id) if !old_item.is_a? ItemData
    old_item_data = GameData::Item.try_get(old_item.id)
	
	
    new_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 new_item = ItemStorageHelper.get_item_data(new_id) if !item.is_a? ItemData
    new_item_data = GameData::Item.try_get(new_item.id)
	
	
    return false if !old_item_data || !new_item_data
    pocket = old_item_data.pocket
    ret = false
    @pockets[pocket].each do |item|
      next if !item || item[0] != old_item
      item[0] = new_item
      ret = true
    end
    return ret
  end

  #=============================================================================

  # Returns whether item has been registered for quick access in the Ready Menu.
  def registered?(item)
    return $PokemonGlobal.hud_favorites.include?(item)
  end

  # Registers the item in the Ready Menu.
  def register(item)
    $PokemonGlobal.hud_favorites.push(item) if !$PokemonGlobal.hud_favorites.include?(item)
  end

  # Unregisters the item from the Ready Menu.
  def unregister(item)
    $PokemonGlobal.hud_favorites.delete(item)
  end



  private
  
  
  def rearrange
    return if @pockets.length == PokemonBag.pocket_count + 1
    @last_viewed_pocket = 1
    new_pockets = []
    @last_pocket_selections = []
    (PokemonBag.pocket_count + 1).times do |i|
      new_pockets[i] = []
      @last_pocket_selections[i] = 0
    end
    @pockets.each do |pocket|
      next if !pocket
      pocket.each do |item|
         item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	     item = ItemStorageHelper.get_item_data(item_id) if !item.is_a? ItemData
	     theitem = item[0] if !item.is_a? ItemData
	     theitem = item[0].id if item.is_a? ItemData
        item_pocket = GameData::Item.get(theitem).pocket
        new_pockets[item_pocket].push(item)
      end
    end
    new_pockets.each_with_index do |pocket, i|
      next if i == 0 || !Settings::BAG_POCKET_AUTO_SORT[i - 1]
      pocket.sort! { |a, b| GameData::Item.keys.index(a[0]) <=> GameData::Item.keys.index(b[0]) }
    end
    @pockets = new_pockets
  end



end


def pbCanRegisterItem?(item)
  return true
end

def favorite_item(item)
return $bag.register(item)
end

def unfavorite_item(item)
return $bag.unregister(item)
end

def item_favorited?(item)
return $bag.registered?(item)
end

