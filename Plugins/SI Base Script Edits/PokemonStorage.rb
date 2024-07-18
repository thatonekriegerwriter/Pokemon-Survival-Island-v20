class PokemonGlobalMetadata
  attr_accessor :iceboxStorageSystems
  attr_accessor :itemStorageSystems
  attr_accessor :pokemonStorageSystems
  attr_accessor :bossesArrayTimer
  attr_accessor :bossesRefightAmt

   alias oldinitglobalsi initialize
  def initialize
    oldinitglobalsi
    @itemStorageSystems              = {}
    @pokemonStorageSystems           = {}
    @iceboxStorageSystems            = {}
    @bossesArrayTimer                    = {}
    @bossesRefightAmt                    = {}
   end






end

class Spoilage
  attr_reader :spoiling

  MAX_SIZE     = 20   # Number of different slots in storage
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize
    @spoiling = []
  end
  
  def spoil(index)
   @spoiling[index]-=1
  end
  
  def add(amt)
	 @spoiling << amt
	 return true
  end

  def remove(index)
    return @spoiling.remove_at(index)
  end

end


class PCItemStorage
  attr_reader :items
  attr_accessor :name

  MAX_SIZE     = 20   # Number of different slots in storage
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize
    @items = []
	@name = ""
    $PokemonGlobal.itemStorageSystems = {} if $PokemonGlobal.itemStorageSystems.nil?
    @name = "Item#{$PokemonGlobal.itemStorageSystems.keys.length}"
	$PokemonGlobal.itemStorageSystems[@name] = [self,Spoilage.new,false]
  end
  def changeName(name)
    $PokemonGlobal.itemStorageSystems[name] = $PokemonGlobal.itemStorageSystems.delete(@name)
  end
  def [](i)
    return @items[i]
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

  def quantity(item)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.can_add?(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def add(item, qty = 1)
    item = GameData::Item.get(item).id
	result = ItemStorageHelper.add(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
    return result
  end

  def remove(item, qty = 1)
    item = GameData::Item.get(item).id
	result = ItemStorageHelper.remove(@items, item, qty)
    return result
  end

end


class IceBoxStorage
  attr_reader :items
  attr_accessor :name

  MAX_SIZE     = 20   # Number of different slots in storage
  MAX_PER_SLOT = 99   # Max. number of items per slot

  def initialize
    @items = []
	@name = ""
    $PokemonGlobal.iceboxStorageSystems = {} if $PokemonGlobal.iceboxStorageSystems.nil?
    @name = "Item#{$PokemonGlobal.iceboxStorageSystems.keys.length}"
	$PokemonGlobal.iceboxStorageSystems[@name] = [self,Spoilage.new,false]
  end
  def changeName(name)
    $PokemonGlobal.iceboxStorageSystems[name] = $PokemonGlobal.iceboxStorageSystems.delete(@name)
  end
  def [](i)
    return @items[i]
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

  def quantity(item)
    item = GameData::Item.get(item).id
    return ItemStorageHelper.quantity(@items, item)
  end

  def can_add?(item, qty = 1)
    item_data = GameData::Item.get(item)
	 if !item_data.is_foodwater?
	   return false
	 end
    item = item_data.id
    return ItemStorageHelper.can_add?(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
  end

  def add(item, qty = 1)
    item = GameData::Item.get(item).id
	result = ItemStorageHelper.add(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
	if result==true
	$PokemonGlobal.iceboxStorageSystems[@name][1].add(item, qty)
	end
    return result
  end

  def remove(item, qty = 1)
    item = GameData::Item.get(item).id
	result = ItemStorageHelper.add(@items, MAX_SIZE, MAX_PER_SLOT, item, qty)
	if result==true
	$PokemonGlobal.iceboxStorageSystems[@name][1].remove(item, qty)
	end
    return result
  end
end


class PokemonStorage
  attr_reader   :boxes
  attr_accessor :currentBox
  attr_writer   :unlockedWallpapers
  attr_accessor :name

  BASICWALLPAPERQTY = 16

  def initialize(maxBoxes = Settings::NUM_STORAGE_BOXES, maxPokemon = PokemonBox::BOX_SIZE)
    @boxes = []
    maxBoxes.times do |i|
      @boxes[i] = PokemonBox.new(_INTL("Box {1}", i + 1), maxPokemon)
      @boxes[i].background = i % BASICWALLPAPERQTY
    end
    @currentBox = 0
    @boxmode = -1
    @unlockedWallpapers = []
    allWallpapers.length.times do |i|
      @unlockedWallpapers[i] = false
    end
	@name = ""
    $PokemonGlobal.pokemonStorageSystems = {} if $PokemonGlobal.pokemonStorageSystems.nil?
    @name = "Box#{$PokemonGlobal.pokemonStorageSystems.keys.length}"
	$PokemonGlobal.pokemonStorageSystems[@name] = self
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
end



def pbBoxesFull?
  if !$PokemonStorage.nil?
  
  
    if $PokemonStorage.full?
   $PokemonGlobal.pokemonStorageSystems.keys.each do |i|
     next if $PokemonGlobal.pokemonStorageSystems[i][2]==false
	  next if $PokemonGlobal.pokemonStorageSystems[i][0].full?
        $PokemonStorage = $PokemonGlobal.pokemonStorageSystems[i][0]
      end
	if $PokemonStorage.nil? && $player.party_full?
	  return true
	end
	  
	  
	  return false
	 else
      return ($player.party_full? && $PokemonStorage.full?)
	 end

  else
  
  
  return $player.party_full?
  end
end



