#TODO: Make way to quickly access food
def oldrodtest
item = ItemData.new(:WOODENPAIL)
item.durability = 67
item.water = 31
pbItemSummaryScreen(item)
$bag.add(item)
end


class Pokemon
  attr_accessor :hidden_modifiers

    alias _SI_Pokemon_init2 initialize
   def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
    _SI_Pokemon_init2(species, level, owner = $player, withMoves = true, recheck_form = true)
      @hidden_modifiers = []
  
   end

   def hidden_modifiers
    @hidden_modifiers = [] if @hidden_modifiers.nil?
    return @hidden_modifiers
   end
end


class ItemData
  attr_accessor :id
  attr_accessor :display_name
  attr_accessor :durability
  attr_accessor :water
  attr_accessor :flags
  attr_accessor :modifiers
  attr_accessor :hidden_modifiers
  attr_accessor :damage_bonus
  attr_accessor :crate_storage
  attr_accessor :food_water_stats
  attr_accessor :berry_stats
  attr_accessor :pokeball_stats
  attr_accessor :capture_styler_stats


  def initialize(id,durability=false,water=false)
    @id         = id
	data = GameData::Item.get(@id)
    @display_name = data.real_name
    @flags      = []
    @durability  = durability
	@durability = 100 if durability==false && ((GameData::Item.get(@id).is_tool? && @id != :STONE) || (GameData::Item.get(@id).is_foodwater? && GameData::Item.get(@id).has_flag?("NoSpoiling")) || GameData::Item.get(@id).is_berry?)
    @water      = water
    @water      = 0 if water==false && GameData::BerryPlant::WATERING_CANS.include?(@id)
    @damage_bonus      = 0
    @crate_storage      = []
    @modifiers  = []
    @hidden_modifiers  = []
    @food_water_stats  = food_water_defs
    @berry_stats  = berry_stats_defs
    @pokeball_stats  = pokeball_stats_defs
    @capture_styler_stats  = capture_styler_stats_defs
	if data.is_berry?
     plant_data = GameData::BerryPlant.try_get(@id)
	  if !plant_data.nil?
	  @berry_stats["Season"] = plant_data.season
	  @berry_stats["Flavor"] = plant_data.flavor
	  @berry_stats["Growth"] = plant_data.hours_per_stage
	  end
	end
	if data.is_pokeball?
	  @pokeball_stats["Catch Rate"] = get_catch_rate_multi(@id)
	
	end
  end





    def get_catch_rate_multi(id)
	  return 1 if id==:POKEBALLC
	  return 1.5 if id==:GREATBALLC
	  return 2 if id==:ULTRABALLC
	end
    def season
	  return @berry_stats["Season"]
	end
    def gain
	  return @berry_stats["Gain"]
	end
    def growth
	  return @berry_stats["Growth"]
	end
    def resistance
	  return @berry_stats["Resistance"]
	end
    def flavor
	  return @berry_stats["Flavor"]
	end
    def spoilage
	  return @food_water_stats["Spoiling"]
	end
    def priority
	  return @food_water_stats["Priority"]
	end
    def servings
	  return @food_water_stats["Servings"]
	end
    def restores
	  return @food_water_stats["Restores"]
	end
    def catchrate
	  return @pokeball_stats["Catch Rate"]
	end
    def health
	  return @pokeball_stats["Health"]
	end
    def ease
	  return @pokeball_stats["Ease of Use"]
	end
    def seffects
	  return @pokeball_stats["Subtle Effects"]
	end
    def quality(type)
	   case type
        when :BERRY	   
	  return @berry_stats["Quality"]
        when :FOOD	  
	  return @food_water_stats["Quality"]
        when :BALL	  
	  return @pokeball_stats["Quality"]
	  end
	end
   

    def modifiers #A System chiefly used by POKeBALL's to decide it's more prominent effects.
     @modifiers = [] if @modifiers.nil?
	 return @modifiers
	end	 
	 
	def name
	  return GameData::Item.get(@id).name
	end

   def berry_stats
    @berry_stats = berry_stats_defs if @berry_stats.nil?
    return @berry_stats
   end

   def pokeball_stats
    @pokeball_stats = pokeball_stats_defs if @pokeball_stats.nil?
    return @pokeball_stats
   end

   def food_water_stats
    @food_water_stats = food_water_defs if @food_water_stats.nil?
    return @food_water_stats
   end



   def damage_bonus
    @damage_bonus = 0 if @damage_bonus.nil?
    return @damage_bonus
   end

   def crate_storage
    @crate_storage = [] if @crate_storage.nil?
    return @crate_storage
   end


    def hidden_modifiers
     @hidden_modifiers = [] if @hidden_modifiers.nil?
	 return @hidden_modifiers
	end

    def hidden_modifiers=(hidden_modifiers)
     @hidden_modifiers = [] if @hidden_modifiers.nil?
	   @hidden_modifiers = hidden_modifiers
	   return @hidden_modifiers
	end


    def modifiers
     @modifiers = [] if @modifiers.nil?
	 return @modifiers
	end

    def modifiers=(modifiers)
     @modifiers = [] if @modifiers.nil?
	   @modifiers = modifiers
	   return @modifiers
	end


   def berry_stats_defs
	   return { 
	  "Growth" => rand(5), # effects the growth rate of plants, meaning higher growth stat leads to plants reaching maturity quicker, rang: 0-4
	  "Resistance" => rand(5), # effects how resistant the plant is to weeds, and pests, rang: 0-4
	  "Flavor" => [0,0,0,0,0], #effects how a pokemon likes a berry
	  "Season" => 0, #effects the season the plant has an affinity for, 0-3
	  "Gain" => 0, # effects the number of fruits that the plant will produce, rang 0-4
	  "Quality" => 0 #effects it's price, and the amount of food/water restored by it, or in something with it, rang: 1-5
	}
	end
  
	def food_water_defs
	   return { 
	  "Spoiling" => rand(5)+1, # effects the rate the food spoils, rang: 1-5
	  "Priority" => rand(5)+1, # effects how much this as an ingredient changes the food, rang: 1-5
	  "Servings" => rand(3)+1, # effects how many times the food can be eaten, rang: 1-3
	  "Flavor" => [0,0,0,0,0], #effects how a pokemon likes the food
	  "Restores" => 0, # effects how much the food restores, rang: 0+
	  "Quality" => 0 #  effects it's price, and the amount of food/water restored by it, rang: 1-5
	}
	end
  
	def pokeball_stats_defs
	   return { 
	  "Catch Rate" => 0, # effects the catch rate of the POKeBALL
	  "Health" => 0, # effects if the POKeBALL can be recovered after being thrown
	  "Ease of Use" => 0, # effects if this POKeBALL takes up your turn to use while in a Command Battle, and the stamina use on the Overworld.
	  "Subtle Effects" => [], # a series of effects the POKeBALL can undergo considering the materials it is created from
	  "Quality" => 0 #  effects it's price, and the happiness of the POKeMON inside.
	}
	end
  
	def capture_styler_stats_defs
	   return { 
	  "Health" => 100, # effects the health of the Capture Styler. If damaged, the durability will decrease and the player will take damage.
	  "Power" => 0, # effects the strength of the Capture Styler. The damage inflicted upon the Pokémon for each successful rotation is increased.
	  "Line" => 0, # effects  the possible length of the line your Capture Styler leaves behind. The longer the line, the bigger the circles you can use to capture the Pokémon.
	  "Recovery" => 1, # effects how much you heal from successfully looping around a Pokemon
	  "LP" => 0, #  effects trigger amount when the Player is low hp (cap at 20)
	  "Fading" => 0, #  makes the line fade slower
	  "Assists" => {} #  possible effects for the styler based on pokemon in the team
	}
	end

	
    def increase_water(amt)
	 return false if @water >= 100
     @water+=amt
	 @water=100 if @water>100
	 return true 
    end
	

    def decrease_water(amt)
     @water-=amt
	 if @water<0
	 @water=0
	 return false
	 end
	 return true
    end


    def decrease_durability(amt)
     @durability-=amt
	 if @durability<=0
	 $bag.remove(self,1)
	 return false
	 end
	 return true
    end


	 def has_flag(flag)
	   return view_flags.include?(flag)
	 end
	
    def increase_durability(amt)
     @durability+=amt
	 @durability=100 if @durability>100
    end
	
	def flags_add(flag)
	  @flags<<flag
	end
	
	def flags_remove(flag)
	  @flags.remove(flag)
	end



	def view_flags
	 flags = []
	 own_flags = @flags
	 own_flags << "Can" if GameData::BerryPlant::WATERING_CANS.include?(@id)
	 flags = (flags + own_flags)
	 data_flags = GameData::Item.get(@id).flags
	 data_flags.each do |flag|
	    if flag.include?("Fling") || flag=="Overworld" || flag=="Coal" || flag=="Durable" || flag=="OffItem" || flag=="HMItem" || flag=="NoSpoiling" || flag=="Apricorn" || flag=="KeyItem"
	    elsif flag=="PlacingItem"
		 flags << "Placeable"
	    elsif flag=="PokeBall"
		 flags << "Pokeball"
	    elsif flag=="TypeGem"
		 flags << "Type Gem"
	    elsif flag=="EvolutionStone"
		 flags << "Evo Stone"
	    elsif flag=="FoodWater"
		 flags << "Food or Water"
	    else
		 flags << flag
		end
	 end
     flags << "TM" if  GameData::Item.get(@id).is_TM?
     flags << "HM" if  GameData::Item.get(@id).is_HM?
     flags << "TR" if  GameData::Item.get(@id).is_TR?
	 return flags
	end

   def identical(item)
     return @id==item.id && @flags==item.flags && @durability==item.durability && @water==item.water && @modifiers==item.modifiers
   end
end



  module ClassMethodsOther
    def register(hash)
      self::DATA[hash[:id]] = self.new(hash)
    end

      def exists?(other)
      return false if other.nil?
      validate other => [Symbol, self, String, Integer, ItemData]
      other = other.id if other.is_a?(self)
      other = other.id if other.is_a?(ItemData)
      other = other.to_sym if other.is_a?(String)
      return !self::DATA[other].nil?
    end

    # @param other [Symbol, self, String, Integer]
    # @return [self]
    def get(other)
      validate other => [Symbol, self, String, Integer, ItemData, Pokemon]
      return other if other.is_a?(self)
      other = other.id if other.is_a?(ItemData)
      other = other.to_sym if other.is_a?(String)
      raise "Unknown ID #{other}." unless self::DATA.has_key?(other)
      return self::DATA[other]
    end

    # @param other [Symbol, self, String, Integer]
    # @return [self, nil]
    def try_get(other)
      return nil if other.nil?
      validate other => [Symbol, self, String, Integer, ItemData]
      return other if other.is_a?(self)
      other = other.id if other.is_a?(ItemData)
      other = other.to_sym if other.is_a?(String)
      return (self::DATA.has_key?(other)) ? self::DATA[other] : nil
    end

    # Returns the array of keys for the data.
    # @return [Array]
    def keys
      return self::DATA.keys
    end

    # Yields all data in the order they were defined.
    def each
      self::DATA.each_value { |value| yield value }
    end

    # Yields all data in alphabetical order.
    def each_alphabetically
      keys = self::DATA.keys.sort { |a, b| self::DATA[a].real_name <=> self::DATA[b].real_name }
      keys.each { |key| yield self::DATA[key] }
    end

    def count
      return self::DATA.length
    end

    def load
      const_set(:DATA, load_data("Data/#{self::DATA_FILENAME}"))
    end

    def save
      save_data(self::DATA, "Data/#{self::DATA_FILENAME}")
    end
  end


module GameData
  class Item
  
  
  
    extend ClassMethodsOther
    include InstanceMethods
	
	
    def is_foodwater?;       return has_flag?("FoodWater"); end   # Does NOT include Red Orb/Blue Orb
    def is_medicine?;        return has_flag?("Medicine"); end
    def is_offitem?;         return has_flag?("OffItem"); end   # Does NOT include Red Orb/Blue Orb
    def is_tool?;            return has_flag?("Tool"); end
    def is_durable?;            return has_flag?("Durable"); end
    def is_weapon?;           return has_flag?("Weapon"); end
    def is_shoes?;            return has_flag?("Shoes"); end
    def is_shirt?;            return has_flag?("Shirt"); end
    def is_pants?;            return has_flag?("Pants"); end
    def is_dart?;            return has_flag?("Dart"); end
    def is_coal?;            return has_flag?("Coal"); end
    def is_overworld?;            return has_flag?("Overworld"); end
    def is_hmitem?;            return has_flag?("HMItem"); end
    def is_placeitem?;            return has_flag?("PlacingItem"); end
    def is_pokeball?;            return has_flag?("PokeBall"); end
  
      TOOLS = [:IRONPICKAXE,:SHOVEL,:MACHETE,:IRONAXE,:IRONHAMMER,:POLE,:OLDROD,:GOODROD,:SUPERROD,:RAFT,:PARAGLIDER]

  






    def spoiling(storage) #$bag, $PokemonGlobal.pcItemStorage, Other
     @durability-=1
	 if @durability==0
	 
	 
	 storage.remove(self,1)
	 potatoes = [:GROWTHMULCH,:DAMPMULCH,:STABLEMULCH,:GOOEYMULCH]
	 storage.add(potatoes[rand(potatoes.length)],amt)
	 
	 
	 end
	 
	 
	 
	
	end

  end
end



def pbGetDurabilityMax(can)
    ret = Settings::BERRY_WATERING_USES_OVERRIDES[can] || Settings::BERRY_WATERING_USES_BEFORE_EMPTY
    return ret
end


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
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0].id).is_pokeball?
      ret = item_slot[1]
    end
    return ret
  end

  def self.whatpkballs(items)
    ret = []
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
    items.each_with_index do |item_slot, i|
      next if !item_slot ||!GameData::Item.get(item_slot[0].id).is_pokeball?
      ret = item_slot[1]
    end
    return ret
  end
  
  

  # Returns the quantity of item in items
  def self.quantity(items, item)
    ret = 0
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
	item = get_item_data(item) if item.is_a?(Symbol)
    items.each_with_index do |item_slot, index| 
	  ret += item_slot[1] if item_slot && item_slot[0].identical(item)
	 end
    return ret
  end

  def self.can_add?(items, max_slots, max_per_slot, item, qty)
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
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
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
	item = get_item_data(item) if item.is_a?(Symbol)
    raise "Invalid value for qty: #{qty}" if qty < 0
    return true if qty == 0
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
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
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
	items = convert_to_itemdata(items) if items.any? { |element| element[0].is_a?(Symbol) }
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
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_tool? || itm.id == :PORTABLECAMP
      items << item
	  end
	end
	end
    return items
  end
  def isPlacableinInventory
    items = []
	$bag.pockets.each do |pocket| 
	next if pocket.nil?
	pocket.each do |i| 
	  i[0] = ItemStorageHelper.get_item_data(i[0]) if i[0].is_a?(Symbol)
	  item = i[0] 
      itm = GameData::Item.get(item)
	  if itm.is_placeitem? && itm.id!=:PORTABLECAMP
      items << item
	  end
	end
	end
    return items
  end
  def amtwithFlag?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.hasflagamt(@pockets[pocket])
  end
  
  def withWhatPokeballs?
    item_data = GameData::Item.try_get(:POKEBALL)
    return false if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.whatpkballs(@pockets[pocket])
  end


  def quantity(item, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    return 0 if !item_data
    pocket = item_data.pocket
    return ItemStorageHelper.quantity(@pockets[pocket], item)
  end

  def has?(item, qty = 1, durability = false, water = false)
    return quantity(item, durability, water) >= qty
  end
  
  
  alias can_remove? has?

  def can_add?(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    return ItemStorageHelper.can_add?(
      @pockets[pocket], max_size, Settings::BAG_MAX_PER_SLOT, item_data.id, qty
    )
  end

  def add(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    return false if !item_data
    pocket = item_data.pocket
    max_size = max_pocket_size(pocket)
    max_size = @pockets[pocket].length + 1 if max_size < 0   # Infinite size
    ret = ItemStorageHelper.add(@pockets[pocket],
                                max_size, Settings::BAG_MAX_PER_SLOT, item, qty)
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
    item_data = GameData::Item.try_get(item.id)
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
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    return false if !item_data
    return @registered_items.include?(item_data.id)
  end

  # Registers the item in the Ready Menu.
  def register(item)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    return if !item_data
    @registered_items.push(item_data.id) if !@registered_items.include?(item_data.id)
  end

  # Unregisters the item from the Ready Menu.
  def unregister(item)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id) if !item.is_a? ItemData
    item_data = GameData::Item.try_get(item.id)
    @registered_items.delete(item_data.id) if item_data
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




#===============================================================================
#
#===============================================================================
class PokemonItemSummary_Scene
  def pbStartScreen(item)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
	@item = item
	item_name = GameData::Item.try_get(item).name
	item_name = item_name.slice(0, 10) if item_name.length > 11
	item_desc = GameData::Item.try_get(item).description
    @rightmost = Graphics.width
    @bottommost = Graphics.height
    @sprites = {}
    @sprites["nubg"] = IconSprite.new(0,0,@viewport)
    @sprites["nubg"].setBitmap("Graphics/Pictures/notebookbg2")
    @sprites["box"]=IconSprite.new(60,80,@viewport)
    @sprites["box"].setBitmap("Graphics/Pictures/craftingMenu/bgBox")
    @sprites["box"]=IconSprite.new(60,80,@viewport)
    @sprites["box"].setBitmap(GameData::Item.icon_filename(@item))


    @sprites["ItemText"]=Window_UnformattedTextPokemon.new(item_name)
    pbPrepareWindow(@sprites["ItemText"])
    @sprites["ItemText"].viewport=@viewport
    @sprites["ItemText"].windowskin=nil
    @sprites["ItemText"].resizeToFit(item_name)
    @sprites["ItemText"].x = 40
    @sprites["ItemText"].y = 33
	
    @sprites["ItemTextDesc"]=Window_UnformattedTextPokemon.new(item_desc)
    pbPrepareWindow(@sprites["ItemTextDesc"])
    @sprites["ItemTextDesc"].viewport=@viewport
    @sprites["ItemTextDesc"].windowskin=nil
    @sprites["ItemTextDesc"].width=180
    @sprites["ItemTextDesc"].height=500
    @sprites["ItemTextDesc"].x = 0
    @sprites["ItemTextDesc"].y = 140
    @sprites["ItemTextDesc"].resizeToFit(item_desc,@sprites["ItemTextDesc"].width)
    @sprites["ItemTextDesc"].x = 0
    @sprites["ItemTextDesc"].y = 140
	
	
	
	if true
    width = 150
	height = 15
    fillWidth = width-2
    fillHeight = height-2
    @sprites["durabilitybarborder"] = BitmapSprite.new(width,height,@viewport)
	@sprites["durabilitybarborder"].visible = false
	if @item.durability!=false && !(GameData::Item.get(@item).is_foodwater?  || GameData::Item.get(@item).is_berry?)
	x=440
	y=80
    @sprites["durabilitybarborder"].x = x-width/2
    @sprites["durabilitybarborder"].y = y-height/2
    @sprites["durabilitybarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )


    hpColors = Color.new(255,182,66)
    shadowHeight = 1
    @sprites["durabilitybarborder"].zoom_x = 0.80
    @sprites["durabilitybarborder"].zoom_y = 0.80
    @sprites["durabilitybarborder"].visible = true
    @sprites["durabilitybarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["durabilitybarfill"].zoom_x = 0.80
    @sprites["durabilitybarfill"].zoom_y = 0.80
	 durability = 100 if @item.durability==false
	 durability = @item.durability if @item.durability!=false
    fillAmount = durability==0  ? 0 : (
      durability*@sprites["durabilitybarfill"].bitmap.width/100
    )
    @sprites["durabilitybarfill"].x = x-fillWidth/2
    @sprites["durabilitybarfill"].y = y-fillHeight/2
    @sprites["durabilitybarfill"].bitmap.fill_rect(
      Rect.new(0,shadowHeight,fillAmount,@sprites["durabilitybarfill"].bitmap.height-shadowHeight), hpColors)

    @sprites["Durability"]=Window_UnformattedTextPokemon.new("Durability:")
    pbPrepareWindow(@sprites["Durability"])
    @sprites["Durability"].viewport=@viewport
    @sprites["Durability"].windowskin=nil
    @sprites["Durability"].width=180
    @sprites["Durability"].height=100
    @sprites["Durability"].zoom_x = 0.80
    @sprites["Durability"].zoom_y = 0.80
    @sprites["Durability"].x = x+14
    @sprites["Durability"].y = y-28
    @sprites["Durability"].resizeToFit("Durability:")
	text = "∞" if @item.durability==false
	text = "#{@item.durability}/100" if @item.durability!=false
	
    @sprites["Durability1"]=Window_UnformattedTextPokemon.new(text)
    pbPrepareWindow(@sprites["Durability1"])
    @sprites["Durability1"].viewport=@viewport
    @sprites["Durability1"].windowskin=nil
    @sprites["Durability1"].width=180
    @sprites["Durability1"].height=100
    @sprites["Durability1"].zoom_x = 0.80
    @sprites["Durability1"].zoom_y = 0.80
    @sprites["Durability1"].x = x+100
    @sprites["Durability1"].y = y-28
    @sprites["Durability1"].resizeToFit(text)
    end

	
	
	
    @sprites["waterbarborder"] = BitmapSprite.new(width,height,@viewport)
	@sprites["waterbarborder"].visible = false
	if GameData::BerryPlant::WATERING_CANS.include?(@item.id) && @item.water != false
	x=440
	y=80
    @sprites["waterbarborder"] = BitmapSprite.new(width,height,@viewport)
    @sprites["waterbarborder"].x = x-width/2
    @sprites["waterbarborder"].y = (y-height/2)+40
    @sprites["waterbarborder"].bitmap.fill_rect(
      (width-fillWidth)/2, (height-fillHeight)/2,
      fillWidth, fillHeight, Color.new(96,96,96)
    )

	@sprites["waterbarborder"].visible = true

    hpColors = Color.new(0, 84, 119)
    shadowHeight = 1
    @sprites["waterbarborder"].zoom_x = 0.80
    @sprites["waterbarborder"].zoom_y = 0.80
    @sprites["waterbarborder"].visible = true
    @sprites["waterbarfill"] = BitmapSprite.new(fillWidth,fillHeight,@viewport)
    @sprites["waterbarfill"].zoom_x = 0.80
    @sprites["waterbarfill"].zoom_y = 0.80
	 durability = 100 if @item.water==false
	 durability = @item.water if @item.water!=false
    fillAmount = durability==0  ? 0 : (
      durability*@sprites["waterbarfill"].bitmap.width/100
    )
    @sprites["waterbarfill"].x = x-fillWidth/2
    @sprites["waterbarfill"].y = (y-fillHeight/2)+40
    @sprites["waterbarfill"].bitmap.fill_rect(
      Rect.new(0,shadowHeight,fillAmount,@sprites["waterbarfill"].bitmap.height-shadowHeight), hpColors)

    @sprites["Water"]=Window_UnformattedTextPokemon.new("Water:")
    pbPrepareWindow(@sprites["Water"])
    @sprites["Water"].viewport=@viewport
    @sprites["Water"].windowskin=nil
    @sprites["Water"].width=180
    @sprites["Water"].height=100
    @sprites["Water"].zoom_x = 0.80
    @sprites["Water"].zoom_y = 0.80
    @sprites["Water"].x = x+14
    @sprites["Water"].y = y-28+50
    @sprites["Water"].resizeToFit("Water:")
	text = ""
	text = "∞" if @item.water==false
	text = "#{@item.water}/100" if @item.water!=false
	
    @sprites["Water1"]=Window_UnformattedTextPokemon.new(text)
    pbPrepareWindow(@sprites["Water1"])
    @sprites["Water1"].viewport=@viewport
    @sprites["Water1"].windowskin=nil
    @sprites["Water1"].width=180
    @sprites["Water1"].height=100
    @sprites["Water1"].zoom_x = 0.80
    @sprites["Water1"].zoom_y = 0.80
    @sprites["Water1"].x = x+100
    @sprites["Water1"].y = y-28+50
    @sprites["Water1"].resizeToFit(text)
	end
	end

    @sprites["Flags"]=Window_UnformattedTextPokemon.new("Flags:")
    pbPrepareWindow(@sprites["Flags"])
    @sprites["Flags"].viewport=@viewport
    @sprites["Flags"].windowskin=nil
    @sprites["Flags"].width=180
    @sprites["Flags"].height=100
    @sprites["Flags"].x = 200
    @sprites["Flags"].y = 38
    @sprites["Flags"].resizeToFit("Flags:")
	theflags = @item.view_flags.join("\n")
	theflags = "None" if theflags== ""
    @sprites["Flags2"]=Window_UnformattedTextPokemon.new(theflags)
    pbPrepareWindow(@sprites["Flags"])
    @sprites["Flags2"].viewport=@viewport
    @sprites["Flags2"].windowskin=nil
    @sprites["Flags2"].width=180
    @sprites["Flags2"].height=300
    @sprites["Flags2"].x = 200
    @sprites["Flags2"].y = 68
    @sprites["Flags2"].resizeToFit(theflags,@sprites["Flags2"].width)



    @sprites["Modifiers"]=Window_UnformattedTextPokemon.new("Modifiers (#{@item.modifiers.length}/3): ")
    pbPrepareWindow(@sprites["Modifiers"])
    @sprites["Modifiers"].viewport=@viewport
    @sprites["Modifiers"].windowskin=nil
    @sprites["Modifiers"].width=180
    @sprites["Modifiers"].height=100
    @sprites["Modifiers"].x = 360
    @sprites["Modifiers"].y = 138
    @sprites["Modifiers"].y -= 100 if !@sprites["durabilitybarborder"].visible && !@sprites["waterbarborder"].visible
    @sprites["Modifiers"].resizeToFit("Modifiers (#{@item.modifiers.length}/3):")
	
	
	theflags = @item.modifiers.join("\n")
	theflags = "None" if theflags== ""
    @sprites["Modifiers2"]=Window_UnformattedTextPokemon.new(theflags)
    pbPrepareWindow(@sprites["Modifiers2"])
    @sprites["Modifiers2"].viewport=@viewport
    @sprites["Modifiers2"].windowskin=nil
    @sprites["Modifiers2"].width=180
    @sprites["Modifiers2"].height=300
    @sprites["Modifiers2"].x = 360
    @sprites["Modifiers2"].y = 168
    @sprites["Modifiers2"].y -= 100 if !@sprites["durabilitybarborder"].visible && !@sprites["waterbarborder"].visible
    @sprites["Modifiers2"].resizeToFit(theflags,@sprites["Modifiers2"].width)

  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end

  def pbEndScreen
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

end

#===============================================================================
#
#===============================================================================

def pbItemSummaryScreen(item)
  potato = nil
  item = ItemStorageHelper.get_item_data(item) if item.is_a?(Symbol)
  potato = item if item.is_a?(Symbol)
  scene = PokemonItemSummary_Scene.new
  screen = PokemonItemSummaryScreen.new(scene,item)
  screen.pbOperations
  return potato
end


class PokemonItemSummaryScreen
  def initialize(scene,item)
    @scene = scene
	@item = item
  end

  def pbDisplay(text, brief = false)
    @scene.pbDisplay(text, brief)
  end

  def pbDisplayPaused(text)
    @scene.pbDisplayPaused(text)
  end

  def pbConfirm(text)
    return @scene.pbConfirm(text)
  end


  def pbOperations
    pbSEPlay("page")
    @scene.pbStartScreen(@item)

      loop do
      Graphics.update
      Input.update
      #pbUpdate
       if Input.trigger?(Input::BACK)
	     pbPlayCloseMenuSE
	     break
	   end
      end
    @scene.pbEndScreen
  end




end

#=