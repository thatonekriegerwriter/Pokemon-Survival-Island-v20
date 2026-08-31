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
    @pockets.each do |pocket|
     pocket.each_with_index do |slot, index|
	   item, amt = slot 
	   next if item.nil?
       next unless item.durable? && item.durability && item.durability <= 0

      pocket[index] = nil
     end
    end
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
  attr_accessor :maxperslot
  attr_accessor :time_last_updated

  BOX_WIDTH  = 9
  BOX_HEIGHT = 3
  MAX_SIZE    = BOX_WIDTH * BOX_HEIGHT
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize(maxsize=MAX_SIZE,maxperslot=MAX_PER_SLOT)
    $PokemonGlobal.itemStorageSystems = {} if $PokemonGlobal.itemStorageSystems.nil?
    @items = []
	@active = false
    @name = "Item#{next_box_id}"
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


  def quantity(item, durability = nil, water = false)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1, durability = nil, water = false)
   @maxperslot = MAX_PER_SLOT if @maxperslot.nil?
   if @maxsize.nil?
   @maxsize = MAX_SIZE
   @originalsize = MAX_SIZE
   end
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.can_add?(@items, @maxsize, @maxperslot, item, qty)
  end

  def add(item, qty = 1, durability = nil, water=false)
   @maxperslot = MAX_PER_SLOT if @maxperslot.nil?
   if @maxsize.nil?
   @maxsize = MAX_SIZE
   @originalsize = MAX_SIZE
   end
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.add(@items, @maxsize, @maxperslot, item, qty)
  end

  def remove(item, qty = 1, durability = nil, water=false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.remove(@items, item, qty)
  end


  def update
    @items.delete_if do |slot|
       next false if slot.nil?
	   item, amt = slot
       item.durable? && item.durability <= 0
	end 
    return unless active?
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
  BOX_WIDTH  = 9
  BOX_HEIGHT = 3
  MAX_SIZE    = BOX_WIDTH * BOX_HEIGHT
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize(electronic=false)
    $PokemonGlobal.iceboxStorageSystems = {} if $PokemonGlobal.iceboxStorageSystems.nil?
    @items = []
	@active = false
	@maxperslot = MAX_PER_SLOT
	@maxsize = electronic==false ? MAX_SIZE : MAX_SIZE*2
	@electronic = electronic
    @name = "Icebox#{next_box_id}"
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


  def quantity(item, durability = nil, water = false)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1, durability = nil, water = false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.can_add?(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def add(item, qty = 1, durability=nil, water=false)
    item_id = GameData::Item.get(item).id if !item.is_a? ItemData
	 item = ItemStorageHelper.get_item_data(item_id,durability,water) if !item.is_a? ItemData
    return ItemStorageHelper.add(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def remove(item, qty = 1, durability = nil, water=false)
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

SaveData.register(:storage_system) do
  ensure_class :PokemonStorage
  save_value { $PokemonStorage }
  load_value { |value| $PokemonStorage = value }
  new_game_value { PokemonStorage.new(Settings::NUM_STORAGE_BOXES,PokemonBox::BOX_SIZE, true) }
  from_old_format { |old_format| old_format[14] }
end

class PokemonStorage
  attr_reader   :boxes
  attr_accessor :currentBox
  attr_writer   :unlockedWallpapers
  attr_accessor :name
  attr_accessor :active
  attr_accessor :time_last_updated

  BASICWALLPAPERQTY = 16

  def initialize(maxBoxes = Settings::NUM_STORAGE_BOXES, maxPokemon = PokemonBox::BOX_SIZE, initial = false)
    @boxes = []
    maxBoxes.times do |i|
      @boxes[i] = PokemonBox.new(_INTL("Box {1}", i + 1), maxPokemon)
      @boxes[i].background = i % BASICWALLPAPERQTY
    end
    @currentBox = 0
    @boxmode = -1
	@initial = initial 
	@time_last_updated = pbGetTimeNow.to_i
    @unlockedWallpapers = []
    allWallpapers.length.times do |i|
      @unlockedWallpapers[i] = false
    end
	unless initial
    $PokemonGlobal.pokemonStorageSystems = {} if $PokemonGlobal.pokemonStorageSystems.nil?
    @name = "Box#{next_box_id}"
	$PokemonGlobal.pokemonStorageSystems[@name] = self
	end
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
    @active = false if @active==0
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
   # puts "Party Full: #{party_full?}"
	#puts "Party: #{self.party.to_s}"
	#puts "Party Length: #{self.party.length}"
	#puts "Party[index]: #{self.party[self.party.length]}"
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
  return !pbAvailablePokemonStorage
end

def pbAvailablePokemonStorage
  systems = $PokemonGlobal&.pokemonStorageSystems
  return true if systems.nil? || systems.empty?
  systems.each_value do |storage|
    next unless storage.active?
    next if storage.full?
	next if storage == $PokemonStorage

    return storage
  end

  return nil 
end 

def pbStorePokemon(pkmn)
  if pbBoxesFull?
    pbMessage(_INTL("There's no room for Pokémon!\1"))
    return
  end
  pkmn.record_first_moves
  if $player.party_full?
    storage = pbAvailablePokemonStorage
	if storage
    stored_box = storage.pbStoreCaught(pkmn)
    box_name   = storage[stored_box].name
    pbMessage(_INTL("{1} has been sent to Box \"{2}\"!", pkmn.name, box_name))
	else
    pbMessage(_INTL("There's no room for Pokémon!\1"))
	end
  else
    $player.party[$player.party.length] = pkmn
  end
end

def pbAddPokemonSilent(pkmn, level = 1, see_form = true)
  return false if !pkmn || pbBoxesFull?
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  $player.pokedex.set_seen(pkmn.species)
  $player.pokedex.set_owned(pkmn.species)
  $player.pokedex.register(pkmn) if see_form
  pkmn.record_first_moves
  if $player.party_full?
    storage = pbAvailablePokemonStorage
    storage.pbStoreCaught(pkmn) if storage
  else
    $player.party[$player.party.length] = pkmn
  end
  return true
end


module Battle::CatchAndStoreMixin
  def pbStorePokemon(pkmn)
    # Nickname the Pokémon (unless it's a Shadow Pokémon)
    if !pkmn.shadowPokemon?
      
	 if nuzlocke_has?(:NICKNAMES)
      nickname = ""
	    loop do
        nickname = @scene.pbNameEntry(_INTL("{1}'s nickname?", pkmn.speciesName), pkmn)
	    break if nickname.length>2
	    end
        pkmn.name = nickname
    elsif $PokemonSystem.givenicknames == 0 &&
         pbDisplayConfirm(_INTL("Would you like to give a nickname to {1}?", pkmn.name))
        nickname = @scene.pbNameEntry(_INTL("{1}'s nickname?", pkmn.speciesName), pkmn)
        pkmn.name = nickname
      end
    end
	pkmn.ace = false
	pkmn.lifespan = 50
	pkmn.food = (rand(100)+1)
    pkmn.water = (rand(100)+1)
    pkmn.age = (rand(40)+1)
  if pkmn.age <= 10
    pkmn.ev[:DEFENSE] = rand(40)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(40)
    pkmn.ev[:ATTACK] = rand(40)
    pkmn.ev[:SPECIAL_ATTACK] = rand(40)
    pkmn.ev[:SPEED] = rand(40)
    pkmn.ev[:HP] = rand(40)
  elsif pkmn.age <= 20 && pkmn.age > 10
    pkmn.ev[:DEFENSE] = rand(80)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(80)
    pkmn.ev[:ATTACK] = rand(80)
    pkmn.ev[:SPECIAL_ATTACK] = rand(80)
    pkmn.ev[:SPEED] = rand(80)
    pkmn.ev[:HP] = rand(80)
  elsif pkmn.age <= 30 && pkmn.age > 20
    pkmn.ev[:DEFENSE] = rand(120)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(120)
    pkmn.ev[:ATTACK] = rand(120)
    pkmn.ev[:SPECIAL_ATTACK] = rand(120)
    pkmn.ev[:SPEED] = rand(120)
    pkmn.ev[:HP] = rand(120)
  elsif pkmn.age <= 40 && pkmn.age > 30
    pkmn.ev[:DEFENSE] = rand(150)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(150)
    pkmn.ev[:ATTACK] = rand(150)
    pkmn.ev[:SPECIAL_ATTACK] = rand(150)
    pkmn.ev[:SPEED] = rand(150)
    pkmn.ev[:HP] = rand(150)
  elsif pkmn.age <= 51 && pkmn.age > 40
    pkmn.ev[:DEFENSE] = rand(200)
    pkmn.ev[:SPECIAL_DEFENSE] = rand(200)
    pkmn.ev[:ATTACK] = rand(200)
    pkmn.ev[:SPECIAL_ATTACK] = rand(200)
    pkmn.ev[:SPEED] = rand(200)
    pkmn.ev[:HP] = rand(200)
  end
    # Store the Pokémon
     if $bag.has?(:MACHETE) && !pkmn.shadowPokemon? && !pkmn.egg? && !pkmn.foreign?($player)
      cmds = [_INTL("Add to your party"),
              _INTL("Send to a Box"),
              _INTL("See {1}'s summary", pkmn.name),
              _INTL("Use {1} for Food", pkmn.name),
              _INTL("Check party")]
     else
      cmds = [_INTL("Add to your party"),
              _INTL("Send to a Box"),
              _INTL("See {1}'s summary", pkmn.name),
              _INTL("Check party")]
     end
      cmds.delete_at(1) if @sendToBoxes == 2
      loop do
        @cmd = @scene.pbShowCommands(_INTL("Where do you want to send {1} to?", pkmn.name), cmds, 99)
        break if @cmd == 99   # Cancelling = send to a Box
        @cmd += 1 if @cmd >= 1 && @sendToBoxes == 2
        case @cmd
        when 0   # Add to your party
		   if $game_temp.in_safari==false
		   if pbPlayer.party.length>5
          pbDisplay(_INTL("Choose a Pokémon in your party to send to your Boxes."))
          party_index = -1
          @scene.pbPartyScreen(0, (@sendToBoxes != 2), 1) { |idxParty, _partyScene|
            party_index = idxParty
            next true
          }
          next if party_index < 0   # Cancelled
          party_size = pbPlayer.party.length
          send_pkmn = pbPlayer.party[party_index]
          storage, stored_box = @peer.pbStorePokemon(pbPlayer, send_pkmn)
	        if !stored_box.nil?
          pbPlayer.party.delete_at(party_index)
          box_name = @peer.pbBoxName(stored_box)
          pbDisplayPaused(_INTL("{1} has been sent to Box \"{2}\".", send_pkmn.name, box_name))
          (party_index...party_size).each do |idx|
            if idx < party_size - 1
              @initialItems[0][idx] = @initialItems[0][idx + 1]
              $game_temp.party_levels_before_battle[idx] = $game_temp.party_levels_before_battle[idx + 1]
              $game_temp.party_critical_hits_dealt[idx] = $game_temp.party_critical_hits_dealt[idx + 1]
              $game_temp.party_direct_damage_taken[idx] = $game_temp.party_direct_damage_taken[idx + 1]
            else
              @initialItems[0][idx] = nil
              $game_temp.party_levels_before_battle[idx] = nil
              $game_temp.party_critical_hits_dealt[idx] = nil
              $game_temp.party_direct_damage_taken[idx] = nil
            end
          end
          end
          else
          storage, stored_box = @peer.pbStorePokemon(pbPlayer, send_pkmn)
		  
          end


          else
		    break
          end
          break
        when 1   # Send to a Box
          break
        when 2   # See X's summary
          pbFadeOutIn {
            summary_scene = PokemonSummary_Scene.new
            summary_screen = PokemonSummaryScreen.new(summary_scene, true)
            summary_screen.pbStartScreen([pkmn], 0)
          }
        when 3   # Check party
         if $bag.has?(:MACHETE) && !pkmn.shadowPokemon? && !pkmn.egg? && !pkmn.foreign?($player)
          pbCookMeat(pkmn)
          return
          else
          @scene.pbPartyScreen(0, true, 2)
          end
        when 4   # Check party
          @scene.pbPartyScreen(0, true, 2)
        end
      end

    # Store as normal (add to party if there's space, or send to a Box if not)
    storage, stored_box = @peer.pbStorePokemon(pbPlayer, pkmn)
	 if !stored_box.nil?
    if stored_box < 0
      pbDisplayPaused(_INTL("{1} has been added to your party.", pkmn.name))
      @initialItems[0][pbPlayer.party.length - 1] = pkmn.item_id if @initialItems
      return
    end
    # Messages saying the Pokémon was stored in a PC box
    box_name = @peer.pbBoxName(storage, stored_box)
    pbDisplayPaused(_INTL("{1} has been sent to \"{2}\"!", pkmn.name, box_name))
	end


  end

  def pbThrowPokeBall(idxBattler, ball, catch_rate = nil, showPlayer = false)
    # Determine which Pokémon you're throwing the Poké Ball at
    if $player.is_it_this_class?(:RANGER,false)
      pbDisplay(_INTL("You are a Ranger, don't use POKeBALLs!"))
      return false
    end
    battler = nil
    if opposes?(idxBattler)
      battler = @battlers[idxBattler]
    else
      battler = @battlers[idxBattler].pbDirectOpposing(true)
    end
    battler = battler.allAllies[0] if battler.fainted?
    # Messages
    itemName = GameData::Item.get(ball).name
    if battler.fainted?
      if itemName.starts_with_vowel?
        pbDisplay(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
      else
        pbDisplay(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
      end
      pbDisplay(_INTL("But there was no target..."))
      return false
    end
    if itemName.starts_with_vowel?
      pbDisplayBrief(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
    else
      pbDisplayBrief(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
    end
    # Animation of opposing trainer blocking Poké Balls (unless it's a Snag Ball
    # at a Shadow Pokémon)
    if trainerBattle? && !(GameData::Item.get(ball).is_snag_ball? && battler.shadowPokemon?)
      @scene.pbThrowAndDeflect(ball, 1)
      pbDisplay(_INTL("The Trainer blocked your Poké Ball! Don't be a thief!"))
      return false
    end
    # Calculate the number of shakes (4=capture)
    pkmn = battler.pokemon
    @criticalCapture = false
    numShakes = pbCaptureCalc(pkmn, battler, catch_rate, ball)
    PBDebug.log("[Threw Poké Ball] #{itemName}, #{numShakes} shakes (4=capture)")
    # Animation of Ball throw, absorb, shake and capture/burst out
    @scene.pbThrow(ball, numShakes, @criticalCapture, battler.index, showPlayer)
    # Outcome message
    case numShakes
    when 0
      pbDisplay(_INTL("It's like the ball didn't even exist!"))
      ball.effects.trigger(:OnFailCatch, battler, self)
    when 1
      pbDisplay(_INTL("The Pokemon broke free easily!"))
      ball.effects.trigger(:OnFailCatch, battler, self)
    when 2
      pbDisplay(_INTL("Aargh! Almost had it!"))
      ball.effects.trigger(:OnFailCatch, battler, self)
    when 3
      pbDisplay(_INTL("Gah! It broke out, and it's not happy!"))
	  
      ball.effects.trigger(:OnFailCatch, battler, self)
    when 4
      pbDisplayBrief(_INTL("Gotcha! {1} was caught!", pkmn.name))
      @scene.pbThrowSuccess   # Play capture success jingle
      pbRemoveFromParty(battler.index, battler.pokemonIndex)
      # Gain Exp
      if Settings::GAIN_EXP_FOR_CAPTURE
        battler.captured = true
        pbGainExp
        battler.captured = false
      end
      battler.pbReset
      if pbAllFainted?(battler.index)
        @decision = (trainerBattle?) ? 1 : 4   # Battle ended by win/capture
      end
      # Modify the Pokémon's properties because of the capture
      if GameData::Item.get(ball).is_snag_ball?
        pkmn.owner = Pokemon::Owner.new_from_trainer(pbPlayer)
      end
      ball.effects.trigger(:onCatch, pkmn, self)
      pkmn.poke_ball = ball
      pkmn.makeUnmega if pkmn.mega?
      pkmn.makeUnprimal
      pkmn.update_shadow_moves if pkmn.shadowPokemon?
      pkmn.record_first_moves
      # Reset form
      pkmn.forced_form = nil if MultipleForms.hasFunction?(pkmn.species, "getForm")
      @peer.pbOnLeavingBattle(self, pkmn, true, true)
      # Make the Poké Ball and data box disappear
      @scene.pbHideCaptureBall(idxBattler)
      # Save the Pokémon for storage at the end of battle
      @caughtPokemon.push(pkmn)
    end
    if numShakes != 4
      @first_poke_ball = ball if !@poke_ball_failed
      @poke_ball_failed = true
	  return false
    end
	return true 
  end

  #=============================================================================
  # Calculate how many shakes a thrown Poké Ball will make (4 = capture)
  #=============================================================================
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    return 4 if $DEBUG && Input.press?(Input::CTRL)
    return 4 if $player.pokedex.owned_count<2
	ball = ball.id
    # Get a catch rate if one wasn't provided
    catch_rate = pkmn.species_data.catch_rate if !catch_rate
    # Modify catch_rate depending on the Poké Ball's effect
    if !pkmn.species_data.has_flag?("UltraBeast") || ball == :BEASTBALL
      catch_rate = ball.effects.trigger(:modifyCatchRate, catch_rate, self, battler)
     # catch_rate = Battle::PokeBallEffects.modifyCatchRate(ball, catch_rate, self, battler)
    else
      catch_rate /= 10
    end

    # First half of the shakes calculation
    a = battler.totalhp
    b = battler.hp
    x = (((3 * battler.totalhp) - (2 * battler.hp)) * catch_rate.to_f) / (3 * battler.totalhp)
    # Calculation modifiers
    if battler.status == :SLEEP || battler.status == :FROZEN
      x *= 2.5
    elsif battler.status != :NONE
      x *= 1.5
    elsif pbInSafari?
	  x /= 3.5
    end
    #INPUT CHECK EDIT
    if Input.repeat?(Input::ACTION)
      x *= 1.2
    end 
    x = x.floor
    x = 1 if x < 1
    # Definite capture, no need to perform randomness checks
    return 4 if x >= 255 || ball.effects.trigger(:isUnconditional, self, battler)
    # Second half of the shakes calculation
    y = (65_536 / ((255.0 / x)**0.1875)).floor
    # Critical capture check

      dex_modifier = 0
      numOwned = $player.pokedex.owned_count
      if numOwned > 600
        dex_modifier = 4
      elsif numOwned > 450
        dex_modifier = 3
      elsif numOwned > 300
        dex_modifier = 2
      elsif numOwned > 150
        dex_modifier = 1
      elsif numOwned > 30
        dex_modifier = 0.5
      end
      dex_modifier *= 2 if $bag.has?(:CATCHINGCHARM)
      c = x * dex_modifier / 12
      # Calculate the number of shakes
	if !pbInSafari?
      if c > 0 && pbRandom(256) < c
        @criticalCapture = true
        return 4 if pbRandom(65_536) < y
        return 0
      end
	end


    # Calculate the number of shakes
    numShakes = 0
    4.times do |i|
      break if numShakes < i
      numShakes += 1 if pbRandom(65_536) < y
    end
    return numShakes
  end
end
class Battle::NullPeer
  def pbBoxName(storage, box);          return "";  end

end 

class Battle::Peer

  def pbBoxName(storage, box)
    return (box < 0) ? "" : storage[box].name
  end

  def pbStorePokemon(player, pkmn)
    if !player.party_full?
      player.party[player.party.length] = pkmn
      return -1
    end
	
	
    storage = pbAvailablePokemonStorage
	
    if !storage
      pbDisplayPaused(_INTL("There's no place to put this if you catch it!"))
	  return nil
	end 
    oldCurBox = storage.currentBox
    storedBox = storage.pbStoreCaught(pkmn)
    if storedBox < 0
      pbDisplayPaused(_INTL("There's no place to put this if you catch it!"))
      return storage, oldCurBox
    end	
	
   return storage, storedBox
  end






end
