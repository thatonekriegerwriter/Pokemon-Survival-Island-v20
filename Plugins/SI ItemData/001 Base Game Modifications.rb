# @return [Integer] 0 = item wasn't used; 1 = item used; 2 = close Bag to use in field
def pbUseItem(bag, item, bagscene = nil)
  itm = GameData::Item.get(item)
  useType = itm.field_use
  if useType == 1   # Item is usable on a Pokémon
    if $player.pokemon_count == 0
      pbMessage(_INTL("There is no Pokémon."))
      return 0
    end
    ret = false
    annot = nil
    if itm.is_evolution_stone?
      annot = []
      $player.party.each do |pkmn|
        elig = pkmn.check_evolution_on_use_item(item)
        annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
      end
    end
    pbFadeOutIn {
      scene = PokemonParty_Scene.new
      screen = PokemonPartyScreen.new(scene, $player.party)
      screen.pbStartScene(_INTL("Use on which Pokémon?"), false, annot)
      loop do
        scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
        chosen = screen.pbChoosePokemon
        if chosen < 0
          ret = false
          break
        end
        pkmn = $player.party[chosen]
        next if !pbCheckUseOnPokemon(item, pkmn, screen)
        qty = 1
        max_at_once = ItemHandlers.triggerUseOnPokemonMaximum(item, pkmn)
        max_at_once = [max_at_once, $bag.quantity(item)].min
        if max_at_once > 1
          qty = screen.scene.pbChooseNumber(
            _INTL("How many {1} do you want to use?", GameData::Item.get(item).name), max_at_once
          )
          screen.scene.pbSetHelpText("") if screen.is_a?(PokemonPartyScreen)
        end
        next if qty <= 0
        ret = ItemHandlers.triggerUseOnPokemon(item, qty, pkmn, screen)
        next unless ret && itm.consumed_after_use?
        bag.remove(item, qty)
        next if bag.has?(item, 1, true)
        pbMessage(_INTL("You used your last {1}.", itm.name)) { screen.pbUpdate }
        break
      end
      screen.pbEndScene
      bagscene&.pbRefresh
    }
    return (ret) ? 1 : 0
  elsif useType == 2 || itm.is_machine?   # Item is usable from Bag or teaches a move
    intret = ItemHandlers.triggerUseFromBag(item)
    if intret && intret >= 0
      bag.remove(item) if intret == 1 && itm.consumed_after_use?
      return intret
    end
    pbMessage(_INTL("Can't use that here."))
    return 0
  end
  pbMessage(_INTL("Can't use that here."))
  return 0
end


def pbUseItemOnPokemon(item, pkmn, scene)
  itm = GameData::Item.get(item)
  # TM or HM
  if itm.is_machine?
    machine = itm.move
    return false if !machine
    movename = GameData::Move.get(machine).name
    if pkmn.shadowPokemon?
      pbMessage(_INTL("Shadow Pokémon can't be taught any moves.")) { scene.pbUpdate }
    elsif !pkmn.compatible_with_move?(machine)
      pbMessage(_INTL("{1} can't learn {2}.", pkmn.name, movename)) { scene.pbUpdate }
    else
      pbMessage(_INTL("\\se[PC access]You booted up {1}.\1", itm.name)) { scene.pbUpdate }
      if pbConfirmMessage(_INTL("Do you want to teach {1} to {2}?", movename, pkmn.name)) { scene.pbUpdate }
        if pbLearnMove(pkmn, machine, false, true) { scene.pbUpdate }
          $bag.remove(item) if itm.consumed_after_use?
          return true
        end
      end
    end
    return false
  end
  # Other item
  qty = 1
  max_at_once = ItemHandlers.triggerUseOnPokemonMaximum(item, pkmn)
  max_at_once = [max_at_once, $bag.quantity(item)].min
  if max_at_once > 1
    qty = scene.scene.pbChooseNumber(
      _INTL("How many {1} do you want to use?", itm.name), max_at_once
    )
    scene.scene.pbSetHelpText("") if scene.is_a?(PokemonPartyScreen)
  end
  return false if qty <= 0
  ret = ItemHandlers.triggerUseOnPokemon(item, qty, pkmn, scene)
  scene.pbClearAnnotations
  scene.pbHardRefresh
  if ret && itm.consumed_after_use?
    $bag.remove(item, qty)
    if !$bag.has?(item, 1, true)
      pbMessage(_INTL("You used your last {1}.", itm.name)) { scene.pbUpdate }
    end
  end
  return ret
end

#TODO: Make way to quickly access food
def oldrodtest
item = ItemData.new(:WOODENPAIL)
item.durability = 67
item.water = 31
pbItemSummaryScreen(item)
$bag.add(item)
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
    attr_reader :weapon_cooldown
    attr_reader :battle_timer
    attr_reader :movement_lock
      SCHEMA["WeaponCooldown"] = [:weapon_cooldown,       "u"]
      SCHEMA["BattleTimer"] = [:battle_timer,       "u"]
      SCHEMA["MovementLock"] = [:movement_lock,       "u"]
	 
	alias SurvivalItemsInitialize initialize
	def initialize(hash)
	  SurvivalItemsInitialize(hash)
      @weapon_cooldown       = hash[:weapon_cooldown]  || 0
      @battle_timer       = hash[:battle_timer]  || 0
      @movement_lock       = hash[:movement_lock]  || 0
	  
	
	
	end
  
  
    extend ClassMethodsOther
    include InstanceMethods
	
	
    def is_foodwater?;       return has_flag?("FoodWater"); end   # Does NOT include Red Orb/Blue Orb
    def is_water?;       return has_flag?("Water"); end   # Does NOT include Red Orb/Blue Orb
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
    def is_placeable?;            return has_flag?("PlacingItem"); end
    def is_pokeball?;            return has_flag?("PokeBall"); end
    def is_apricorn?;            return has_flag?("Apricorn"); end
    def is_styler?;            return has_flag?("CaptureStyler"); end
    def has_water_meter?;            return has_flag?("WaterDura"); end
  
  
  
  
      TOOLS = [:IRONPICKAXE,:SHOVEL,:MACHETE,:IRONAXE,:IRONHAMMER,:POLE,:OLDROD,:GOODROD,:SUPERROD,:RAFT,:PARAGLIDER]

  






  end
end

