class PokemonGlobalMetadata
  attr_accessor :iceboxStorageSystems
  attr_accessor :itemStorageSystems
  attr_accessor :pokemonStorageSystems
  attr_accessor :storagesystemssteps
  attr_accessor :storagesystemssteps
  attr_accessor :bossesArrayTimer
  attr_accessor :bossesRefightAmt

   alias oldinitglobalsi initialize
  def initialize
    oldinitglobalsi
    @itemStorageSystems              = {}
    @pokemonStorageSystems           = {}
    @iceboxStorageSystems            = {}
    @storagesystemssteps             = 0
    @bossesArrayTimer                    = {}
    @bossesRefightAmt                    = {}
   end


  def storagesystemssteps
    @storagesystemssteps = 0 if @storagesystemssteps.nil?
	return @storagesystemssteps
  end


end

class PokemonBag
   attr_accessor :time_last_updated
  alias _SI_Bag_Init2222 initialize
  def initialize
    _SI_Bag_Init2222
    @time_last_updated = pbGetTimeNow.to_i
  end

  def update
    @time_last_updated = pbGetTimeNow.to_i if @time_last_updated.nil?
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    time_per_stage = 5400
	stages_passed = time_delta / time_per_stage
	#puts "#{time_delta}/#{time_per_stage} (#{stages_passed})"
    return if stages_passed <= 0
	 @pockets.each do |pocket|
      pocket.each do |slot|
	   next if slot.nil?
	   item, amt = slot
	   next if item.nil?
       next unless item.respond_to?(:update)
	   item.update(stages_passed) 
      end
	 end 
	
   @time_last_updated = time_now.to_i
  end


end 

class PokemonBox
  attr_reader   :pokemon
  attr_accessor :name
  attr_accessor :background

  BOX_WIDTH  = 9
  BOX_HEIGHT = 3
  BOX_SIZE   = BOX_WIDTH * BOX_HEIGHT

  def initialize(name, maxPokemon = BOX_SIZE)
    @name = name
    @background = 0
    @pokemon = []
    maxPokemon.times { |i| @pokemon[i] = nil }
  end

  def length
    return @pokemon.length
  end

  def nitems
    ret = 0
    @pokemon.each { |pkmn| ret += 1 if !pkmn.nil? }
    return ret
  end

  def full?
    return nitems == self.length
  end

  def empty?
    return nitems == 0
  end

  def [](i)
    return @pokemon[i]
  end

  def []=(i, value)
    @pokemon[i] = value
  end

  def each
    @pokemon.each { |item| yield item }
  end

  def clear
    @pokemon.clear
  end
end


class PCItemStorage
  attr_accessor :items
  attr_accessor :name
  attr_accessor :active
  attr_accessor :maxsize
  attr_accessor :maxperslot
  attr_accessor :time_last_updated

  MAX_SIZE_OLD    = 48   # Number of different slots in storage
  MAX_SIZE    = 27
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize(maxsize=MAX_SIZE,maxperslot=MAX_PER_SLOT)
    $PokemonGlobal.itemStorageSystems = {} if $PokemonGlobal.itemStorageSystems.nil?
    @items = []
	@active = false
    @name = "Item#{next_box_id}"
	@maxsize = maxsize
	@maxperslot = maxperslot
	@originalsize = maxsize
	@originalperslot = maxperslot
	@time_last_updated = pbGetTimeNow.to_i
	$PokemonGlobal.itemStorageSystems[@name] = self
  end
  def next_box_id
  max = $PokemonGlobal.itemStorageSystems.keys
            .map { |k| k[/\d+/].to_i }
            .max || -1
  return max + 1
  end
  
  
  
  def maxsize
   if @maxsize.nil? || @maxsize==MAX_SIZE_OLD
   @maxsize = MAX_SIZE
   @originalsize = MAX_SIZE
   end
   return @maxsize
  end
  def maxperslot
   @maxperslot = MAX_PER_SLOT if @maxperslot.nil?
  end
  def add_max_size(amt)
   @maxsize+=amt
  end
  def remove_max_size(amt)
   @maxsize-=amt if @maxsize-amt>=@originalsize
  end
  def [](i)
    return @items[i]
  end

  def active?
    return @active
  end

  def active
    @active = false if @active.nil?
    return @active
  end

  def length
    return @items.length
  end

  def empty?
    return @items.length == 0
  end

  def clear
    @items.clear
  end

  # Unused
  def get_item(index)
    return (index < 0 || index >= @items.length) ? nil : @items[index][0]
  end

  # Number of the item in the given index
  # Unused
  def get_item_count(index)
    return (index < 0 || index >= @items.length) ? 0 : @items[index][1]
  end


  def quantity(item, durability = false, water = false)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1, durability = false, water = false)
   @maxperslot = MAX_PER_SLOT if @maxperslot.nil?
   if @maxsize.nil?
   @maxsize = MAX_SIZE
   @originalsize = MAX_SIZE
   end
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.can_add?(@items, @maxsize, @maxperslot, item, qty)
  end

  def add(item, qty = 1, durability=false, water=false)
   @maxperslot = MAX_PER_SLOT if @maxperslot.nil?
   if @maxsize.nil?
   @maxsize = MAX_SIZE
   @originalsize = MAX_SIZE
   end
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.add(@items, @maxsize, @maxperslot, item, qty)
  end

  def remove(item, qty = 1, durability=false, water=false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.remove(@items, item, qty)
  end


  def update
    return if !active?
    @time_last_updated = pbGetTimeNow.to_i if @time_last_updated.nil?
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    time_per_stage = 5400
	stages_passed = time_delta / time_per_stage
    return if stages_passed <= 0
      @items.each do |slot|
	   next if slot.nil?
	   item, amt = slot
       next unless item.respond_to?(:update)
	   item.update(stages_passed) 
      end
	
	
   @time_last_updated = time_now.to_i
  end


end


class IceBoxStorage
  attr_reader :items
  attr_reader :electronic 
  attr_accessor :maxperslot
  attr_accessor :maxsize
  attr_accessor :name
  attr_accessor :active
  attr_accessor :time_last_updated

  MAX_SIZE     = 9   # Number of different slots in storage
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize(electronic=false)
    $PokemonGlobal.iceboxStorageSystems = {} if $PokemonGlobal.iceboxStorageSystems.nil?
    @items = []
	@active = false
	@maxperslot = MAX_PER_SLOT
	@maxsize = electronic==false ? MAX_SIZE : MAX_SIZE*2
	@electronic = electronic
    @name = "Box#{next_box_id}"
	@time_last_updated = pbGetTimeNow.to_i
	$PokemonGlobal.iceboxStorageSystems[@name] = self
  end
  def next_box_id
  max = $PokemonGlobal.iceboxStorageSystems.keys
            .map { |k| k[/\d+/].to_i }
            .max || -1
  return max + 1
  end
 
  def [](i)
    return @items[i]
  end

  def active?
    return @active
  end

  def active
    @active = false if @active.nil?
    return @active
  end


  def length
    return @items.length
  end

  def empty?
    return @items.length == 0
  end

  def clear
    @items.clear
  end

  # Unused
  def get_item(index)
    return (index < 0 || index >= @items.length) ? nil : @items[index][0]
  end

  # Number of the item in the given index
  # Unused
  def get_item_count(index)
    return (index < 0 || index >= @items.length) ? 0 : @items[index][1]
  end


  def quantity(item, durability = false, water = false)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1, durability = false, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.can_add?(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def add(item, qty = 1, durability=false, water=false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.add(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def remove(item, qty = 1, durability=false, water=false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.remove(@items, item, qty)
  end
  def update
    return if !active?
    @time_last_updated = pbGetTimeNow.to_i if @time_last_updated.nil?
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    time_per_stage = @electronic==true ? 14400 : 10800
	stages_passed = time_delta / time_per_stage
    return if stages_passed <= 0
      @items.each do |slot|
	   next if slot.nil?
	   item, amt = slot
       next unless item.respond_to?(:update)
	   item.update(stages_passed) 
      end
	
	
   @time_last_updated = time_now.to_i
  end


end


class PokemonStorage
  attr_reader   :boxes
  attr_accessor :currentBox
  attr_writer   :unlockedWallpapers
  attr_accessor :name
  attr_accessor :active
  attr_accessor :time_last_updated

  BASICWALLPAPERQTY = 16

  def initialize(maxBoxes = Settings::NUM_STORAGE_BOXES, maxPokemon = PokemonBox::BOX_SIZE)
    @boxes = []
    maxBoxes.times do |i|
      @boxes[i] = PokemonBox.new(_INTL("Box {1}", i + 1), maxPokemon)
      @boxes[i].background = i % BASICWALLPAPERQTY
    end
    @currentBox = 0
    @active = 0
    @boxmode = -1
	@time_last_updated = pbGetTimeNow.to_i
    @unlockedWallpapers = []
    allWallpapers.length.times do |i|
      @unlockedWallpapers[i] = false
    end
    $PokemonGlobal.pokemonStorageSystems = {} if $PokemonGlobal.pokemonStorageSystems.nil?
    @name = "Box#{next_box_id}"
	$PokemonGlobal.pokemonStorageSystems[@name] = self
  end
  
  def next_box_id
  max = $PokemonGlobal.pokemonStorageSystems.keys
            .map { |k| k[/\d+/].to_i }
            .max || -1
  return max + 1
  end
  
  def box(index=0)
    return @boxes[index]
  end 
  
  
  def box_pokemon
   return @boxes[0].pokemon
  end 
  
  def active
    @active = false if @active.nil?
    return @active
  end
  
  def active?
    @active
  end 
  
  def allWallpapers
    return [
      # Basic wallpapers
      _INTL("Forest"), _INTL("City"), _INTL("Desert"), _INTL("Savanna"),
      _INTL("Crag"), _INTL("Volcano"), _INTL("Snow"), _INTL("Cave"),
      _INTL("Beach"), _INTL("Seafloor"), _INTL("River"), _INTL("Sky"),
      _INTL("Poké Center"), _INTL("Machine"), _INTL("Checks"), _INTL("Simple"),
      # Special wallpapers
      _INTL("Space"), _INTL("Backyard"), _INTL("Nostalgic 1"), _INTL("Torchic"),
      _INTL("Trio 1"), _INTL("PikaPika 1"), _INTL("Legend 1"), _INTL("Team Galactic 1"),
      _INTL("Distortion"), _INTL("Contest"), _INTL("Nostalgic 2"), _INTL("Croagunk"),
      _INTL("Trio 2"), _INTL("PikaPika 2"), _INTL("Legend 2"), _INTL("Team Galactic 2"),
      _INTL("Heart"), _INTL("Soul"), _INTL("Big Brother"), _INTL("Pokéathlon"),
      _INTL("Trio 3"), _INTL("Spiky Pika"), _INTL("Kimono Girl"), _INTL("Revival")
    ]
  end

  def unlockedWallpapers
    @unlockedWallpapers = [] if !@unlockedWallpapers
    return @unlockedWallpapers
  end

  def isAvailableWallpaper?(i)
    @unlockedWallpapers = [] if !@unlockedWallpapers
    return true if i < BASICWALLPAPERQTY
    return true if @unlockedWallpapers[i]
    return false
  end

  def availableWallpapers
    ret = [[], []]   # Names, IDs
    papers = allWallpapers
    @unlockedWallpapers = [] if !@unlockedWallpapers
    papers.length.times do |i|
      next if !isAvailableWallpaper?(i)
      ret[0].push(papers[i])
      ret[1].push(i)
    end
    return ret
  end

  def party
    $player.party
  end

  def party=(_value)
    raise ArgumentError.new("Not supported")
  end

  def party_full?
    return $player.party_full?
  end

  def maxBoxes
    return @boxes.length
  end

  def maxPokemon(box)
    return 0 if box >= self.maxBoxes
    return (box < 0) ? Settings::MAX_PARTY_SIZE : self[box].length
  end

  def full?
    self.maxBoxes.times do |i|
      return false if !@boxes[i].full?
    end
    return true
  end

  def pbFirstFreePos(box)
    if box == -1
      ret = self.party.length
      return (ret >= Settings::MAX_PARTY_SIZE) ? -1 : ret
    end
    maxPokemon(box).times do |i|
      return i if !self[box, i]
    end
    return -1
  end

  def [](x, y = nil)
    if y.nil?
      return (x == -1) ? self.party : @boxes[x]
    else
      @boxes.each do |i|
        raise "Box is a Pokémon, not a box" if i.is_a?(Pokemon)
      end
      return (x == -1) ? self.party[y] : @boxes[x][y]
    end
  end

  def []=(x, y, value)
    if x == -1
      self.party[y] = value
    else
      @boxes[x][y] = value
    end
  end

  def pbCopy(boxDst, indexDst, boxSrc, indexSrc)
    if indexDst < 0 && boxDst < self.maxBoxes
      found = false
      maxPokemon(boxDst).times do |i|
        next if self[boxDst, i]
        found = true
        indexDst = i
        break
      end
      return false if !found
    end
    if boxDst == -1   # Copying into party
      return false if party_full?
      self.party[self.party.length] = self[boxSrc, indexSrc]
      self.party.compact!
    else   # Copying into box
      pkmn = self[boxSrc, indexSrc]
      raise "Trying to copy nil to storage" if !pkmn
      if Settings::HEAL_STORED_POKEMON
        old_ready_evo = pkmn.ready_to_evolve
        pkmn.heal
        pkmn.ready_to_evolve = old_ready_evo
      end
      self[boxDst, indexDst] = pkmn
    end
    return true
  end

  def pbMove(boxDst, indexDst, boxSrc, indexSrc)
    return false if !pbCopy(boxDst, indexDst, boxSrc, indexSrc)
    pbDelete(boxSrc, indexSrc)
    return true
  end

  def pbMoveCaughtToParty(pkmn)
    return false if party_full?
    self.party[self.party.length] = pkmn
  end

  def pbMoveCaughtToBox(pkmn, box)
    maxPokemon(box).times do |i|
      next unless self[box, i].nil?
      if Settings::HEAL_STORED_POKEMON && box >= 0
        old_ready_evo = pkmn.ready_to_evolve
        pkmn.heal
        pkmn.ready_to_evolve = old_ready_evo
      end
      self[box, i] = pkmn
      return true
    end
    return false
  end

  def pbStoreCaught(pkmn)
    if Settings::HEAL_STORED_POKEMON && @currentBox >= 0
      old_ready_evo = pkmn.ready_to_evolve
      pkmn.heal
      pkmn.ready_to_evolve = old_ready_evo
    end
    maxPokemon(@currentBox).times do |i|
      if self[@currentBox, i].nil?
        self[@currentBox, i] = pkmn
        return @currentBox
      end
    end
    self.maxBoxes.times do |j|
      maxPokemon(j).times do |i|
        next unless self[j, i].nil?
        self[j, i] = pkmn
        @currentBox = j
        return @currentBox
      end
    end
    return -1
  end

  def pbDelete(box, index)
    if self[box, index]
      self[box, index] = nil
      self.party.compact! if box == -1
    end
  end

  def clear
    self.maxBoxes.times { |i| @boxes[i].clear }
  end
 
  def update
    return if !active?
    @time_last_updated = pbGetTimeNow.to_i if @time_last_updated.nil?
    time_now = pbGetTimeNow
    time_delta = time_now.to_i - @time_last_updated
    time_per_stage = 5400
	stages_passed = time_delta / time_per_stage
    return if stages_passed <= 0
      pokemon = @boxes[0]
      pokemon.each do |pkmn|
	    pkmn.update if pkmn.respond_to?(:update)
      end
	
	
   @time_last_updated = time_now.to_i
  end

end

EventHandlers.add(:on_frame_update, :update_storages,
  proc { 
    next if !$scene.is_a?(Scene_Map)
	
	$bag.update
    $PokemonGlobal.pokemonStorageSystems.each_key do |key|
	  $PokemonGlobal.pokemonStorageSystems[key] = $PokemonGlobal.pokemonStorageSystems[key][0] if $PokemonGlobal.pokemonStorageSystems[key].is_a? Array
	  $PokemonGlobal.pokemonStorageSystems[key].update
	end
    $PokemonGlobal.itemStorageSystems.each_key do |key|
	  $PokemonGlobal.itemStorageSystems[key] = $PokemonGlobal.itemStorageSystems[key][0] if $PokemonGlobal.itemStorageSystems[key].is_a? Array
	  $PokemonGlobal.itemStorageSystems[key].update
	end
    $PokemonGlobal.iceboxStorageSystems.each_key do |key|
	  $PokemonGlobal.iceboxStorageSystems[key] = $PokemonGlobal.iceboxStorageSystems[key][0] if $PokemonGlobal.iceboxStorageSystems[key].is_a? Array
	  $PokemonGlobal.iceboxStorageSystems[key].update
	end



  }
)


def pbBoxesFull?
  return false unless $player.party_full?
  systems = $PokemonGlobal&.pokemonStorageSystems
  return true if systems.nil? || systems.empty?
  if $PokemonStorage && $PokemonStorage.active? && !$PokemonStorage.full?
    return false
  end
  
  
  systems.each_value do |system|
    next unless system.active?
    next if system.full?

    $PokemonStorage = system
    return false
  end
  
  return true 
end



