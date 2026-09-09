module GameData
 class Placeable
    attr_reader :id
    attr_reader :usable_locations
    attr_reader :placement_coordinates
    attr_reader :size
    attr_reader :needs_power
    attr_reader :produces_power
    attr_reader :produces_water
    attr_reader :needs_water
    attr_reader :battery_box
    attr_reader :width
    attr_reader :height
    attr_reader :center
    attr_reader :image
    attr_reader :packable
    attr_reader :through
    attr_reader :trigger
    attr_reader :step_anime
    attr_reader :script
    attr_reader :animates_unless_stored
    attr_reader :internal_data
    attr_reader :correct_terrain

    DATA = {}
    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end
 
    def initialize(hash)
      @id           = hash[:id]
      @usable_locations    = hash[:usable_locations]         || [:BASE_INTERIOR]  #Options are :BASE_INTERIOR, :BASE_EXTERIOR, :BASE, :WILDS, and :ANY
      @placement_coordinates    = hash[:placement_coordinates]         || { 2 => [0,1], 4 => [-1,0], 6 => [+1,0], 8 => [0,-1]}
	  @assignable = hash[:assignable] || false 
      @assignable_check       = hash[:assignable_check] || proc { |item, pkmn| true }
	  @needs_power = hash[:needs_power] || false 
	  @needs_water = hash[:needs_water] || false 
	  @produces_power = hash[:produces_power] || false 
	  @produces_water = hash[:produces_water] || false 
	  @battery_box = hash[:battery_box] || false 
	  @width = hash[:width] || 1
	  @height = hash[:height] || 1
	  @center = hash[:center] || false
	  @image = hash[:image] || "craftingStations/CraftingStation"
	  @packable = hash[:packable] || false
	  @through = hash[:through] || false
	  @trigger = hash[:trigger] || 0
	  @step_anime = hash[:step_anime] || false
	  @script = hash[:script] || ["object = get_own_event", "ItemHandlers.triggerUseFromEvent(object.type,'[REPLACE_WITH_KEY_ID]') if defined?(object.type)"]
	  @animates_unless_stored = hash[:animates_unless_stored] || false
	  @internal_data = hash[:internal_data] || []
	  @correct_terrain = hash[:correct_terrain] || []
    end
	
    def name
      return GameData::Item.try_get(@id).name
    end
	
	def initialize_internal_data?
	  !@internal_data.empty?
	end 
	
	def assignable?(item, pkmn)
	   @assignable && @assignable_check.call(item, pkmn)
	end 
	
   def self.all
    DATA.values
   end 
   
   def placement_offset(direction, player_direction = $game_player.direction)
    data = @placement_coordinates[direction]
    if data.is_a?(Hash)
	 # puts direction
	 # puts player_direction
	 # puts data[player_direction].to_s
      data[player_direction] || [0, 1]
   else
     @placement_coordinates[player_direction] || [0, 1]
   end
   end
    
	def event_name(direction = nil, store = false )
	  return "Size(2,1).noshadow" if @id == :BEDROLL && !store && direction && (direction == 4 || direction == 6)
	  return "playertorch(5,5)" if @id == :TORCH
	  base = ""
	  base += "Size(#{@width},#{@height})" if @width > 1 || @height > 1
	  base += ".center" if @center 
	  base += ".noshadow"
	  return base 
	end 
   
   def get_image(direction = nil, store = false )
     return "craftingStations/PackedBedroll" if @id == :BEDROLL && store && @packable
     return "craftingStations/Packed" if store && @packable
     return "craftingStations/bedsideways" if @id == :BEDROLL && !store && [4, 6].include?(direction)
	 return @image
   end 
   
   def correct_terrain?(x, y, map_id = $game_map.map_id)
    return true if @correct_terrain.empty?
    if $map_factory
     terrain_tag = $map_factory.getTerrainTagFromCoords(map_id, x, y, false) 
	else
     terrain_tag = $game_map.terrain_tag(x, y, false)
	end
	return @correct_terrain.include?(terrain_tag.id)
   end 
   
    def usable_here?(map_id = $game_map.map_id)
	   return true if @usable_locations.include?(:ANY)
       map_metadata = GameData::MapMetadata.try_get(map_id)
	   if map_metadata
	    associated_base = map_metadata.associated_base
	     if associated_base
	      base = GameData::Base.get(associated_base)
		  return true if base.outdoor_maps.include?(map_id) && @usable_locations.include?(:OUTSIDE)
		  return false if base.indoor_maps.include?(map_id) && @usable_locations.include?(:OUTSIDE)
		  return true if @usable_locations.include?(:BASE)
		  return true if base.outdoor_maps.include?(map_id) && @usable_locations.include?(:BASE_EXTERIOR)
		  return true if base.indoor_maps.include?(map_id) && @usable_locations.include?(:BASE_INTERIOR)
		  return true if base.can_place_wilds && @usable_locations.include?(:WILDS)
		 else
	      return true if @usable_locations.include?(:WILDS)
		  return true if @usable_locations.include?(:OUTSIDE) && map_metadata.outdoor_map
		 end
	   else
	     return true if @usable_locations.include?(:WILDS)
	   end 


	   return false 
	end 


 end
end 




GameData::Placeable.register({ :id            => :CRAFTINGBENCH})
GameData::Placeable.register({ :id            => :OVPOT, :usable_locations => [:ANY], :image => "craftingStations/pot", :script => []})
GameData::Placeable.register({ :id            => :EGG, :usable_locations => [:ANY], :image => "craftingStations/egg", :script => []})
GameData::Placeable.register({ :id            => :CAMPSITEDOOR, :usable_locations => [:ANY], :image => "", :trigger => 1, :script => ["campsiteDoorEntry"]})
GameData::Placeable.register({ :id            => :APRICORNCRAFTING, :image => "craftingStations/PokeballStationUp"})
GameData::Placeable.register({ :id            => :MEDICINEPOT, :image => "craftingStations/pot"})
GameData::Placeable.register({ :id            => :BEDROLL, :width => 1, :height => 2, :packable => true, :image => "craftingStations/bed", :placement_coordinates =>   { 
    2 => {
      2 => [0, 1],
      4 => [-1, 0],
      6 => [1, 0],
      8 => [0, -1]
    },
  4 => {
    2 => [-1, 1],
    4 => [-2, 0],
    6 => [-2, 0],
    8 => [-1, -1]
  },
  6 => {
    2 => [0, 1],
    4 => [1, 0],
    6 => [1, 0],
    8 => [0, -1]
  },
    8 => {
      2 => [0, 2],
      4 => [-1, 1],
      6 => [1, 1],
      8 => [0, -1]
    }
  }})
GameData::Placeable.register({ :id            => :CAULDRON, :image => "craftingStations/Cauldron", :usable_locations => [:BASE]})
GameData::Placeable.register({ :id            => :UPGRADEDCRAFTINGBENCH, :image => "craftingStations/UCraftingStation"})
GameData::Placeable.register({ :id            => :MODIFICATIONTABLE, :image => "craftingStations/ModificationTable"})
GameData::Placeable.register({ :id            => :SIFTER, :image => "craftingStations/Sifter"})

GameData::Placeable.register({ :id            => :STATUE, :usable_locations => [:ANY]})

GameData::Placeable.register({ :id            => :BUTCHERTABLE, :usable_locations => [:BASE], :image => "craftingStations/ButcherTable"})
GameData::Placeable.register({ :id            => :GARBAGEBIN, :usable_locations => [:BASE], :image => "craftingStations/GarbageBin"})
GameData::Placeable.register({ :id            => :ITEMCRATE, :usable_locations => [:BASE], :image => "craftingStations/crateidown"})
GameData::Placeable.register({ :id            => :PKMNCRATE, :usable_locations => [:BASE], :image => "craftingStations/cratedown"})

GameData::Placeable.register({ :id            => :TORCH, :usable_locations => [:ANY], :image => "craftingStations/Legends_Torch"})


GameData::Placeable.register({ :id            => :GRAVE, :usable_locations => [:OUTSIDE], :image => "craftingStations/Grave"})
GameData::Placeable.register({ :id            => :ADVENTUREFLAG, :animates_unless_stored => true , :width => 1, :height => 3, :through => true, :packable => true, :usable_locations => [:BASE_EXTERIOR], :image => "craftingStations/AdventureFlag"})
GameData::Placeable.register({ :id            => :WARDINGTOTEM, :usable_locations => [:BASE_EXTERIOR], :image => "craftingStations/WardingTotem"})

GameData::Placeable.register({ :id            => :SPRINKLER, :needs_water => true, :needs_power => true, :usable_locations => [:BASE], :image => "craftingStations/sprink"})
GameData::Placeable.register({ :id            => :MACHINEBOX, :battery_box => true, :image => "craftingStations/MachineBox"})
GameData::Placeable.register({ :id            => :ELECTRICPRESS, :needs_power => true, :image => "craftingStations/ElectricPress"})
GameData::Placeable.register({ :id            => :ELECTRICFURNACE, :needs_power => true, :image => "craftingStations/ElectricFurnace"})
GameData::Placeable.register({ :id            => :SEWINGMACHINE, :needs_power => true, :image => "craftingStations/SewingMachine"})
GameData::Placeable.register({ :id            => :ELECTRICSIFTER, :needs_power => true, :image => "craftingStations/ElectricSifter"})
GameData::Placeable.register({ :id            => :ELECTRICOREWASHER, :needs_power => true, :image => "craftingStations/ElectricOreWasher"})
GameData::Placeable.register({ :id            => :ELECTRICPURIFIER, :needs_water => true, :packable => true, :needs_power => true, :image => "craftingStations/waterpurifier"})

GameData::Placeable.register({ :id            => :ELECTRICLIGHT, :usable_locations => [:ANY], :needs_power => true, :image => "craftingStations/Lamp"})

GameData::Placeable.register({ :id            => :COALGENERATOR, :usable_locations => [:BASE], :produces_power => true, :image => "craftingStations/generator" })
GameData::Placeable.register({ :id            => :HYDROGENERATOR, :correct_terrain => [:StillWater, :Water, :DeepWater], :usable_locations => [:BASE_EXTERIOR], :produces_power => true, :image => "craftingStations/waterwheel" })
GameData::Placeable.register({ :id            => :WINDGENERATOR, :animates_unless_stored => true, :packable => true, :usable_locations => [:BASE_EXTERIOR], :produces_power => true, :image => "craftingStations/windmill" })
GameData::Placeable.register({ :id            => :SOLARGENERATOR, :usable_locations => [:BASE_EXTERIOR], :produces_power => true, :image => "craftingStations/SolarPanel" })

GameData::Placeable.register({ :id            => :PORTABLECAMP, :width => 3, :height => 3, :packable => true, :usable_locations => [:WILDS], :image => "craftingStations/Tent", :placement_coordinates =>  { 2 => [-1,-1], 4 => [-1,-1], 6 => [-1,-1], 8 => [-1,-1]}})


GameData::Placeable.register({ :id            => :ELECTRICQUARRY, :width => 3, :height => 3, :correct_terrain => [:Stone, :Rock], :needs_power => true, :usable_locations => [:BASE_EXTERIOR], :image => "craftingStations/bigmachine" })
GameData::Placeable.register({ :id            => :ELECTRICPUMP, :width => 3, :height => 3, :correct_terrain => [:StillWater, :Water, :DeepWater], :needs_power => true, :usable_locations => [:BASE_EXTERIOR], :produces_water => true, :image => "craftingStations/bigmachine2" })
GameData::Placeable.register({ :id            => :RESEARCHTABLE, :assignable => true, :image => "craftingStations/ResearchTable"})
GameData::Placeable.register({ :id            => :BERRYPOT, :assignable => true, :image => "craftingStations/BerryPot", :usable_locations => [:BASE]}) 
GameData::Placeable.register({ :id            => :BERRYPLANT, :assignable => true, :usable_locations => [:ANY]}) #If Mushroom, absolutely shoot up mushroom pokemon growth stonks
GameData::Placeable.register({ :id            => :GRINDER, :assignable => true, :image => "craftingStations/Grinder"})
GameData::Placeable.register({ :id            => :CUTTER, :assignable => true, :image => "craftingStations/Cutter"})
GameData::Placeable.register({ :id            => :ELECTRICGRINDER, :assignable => true, :needs_power => true})
GameData::Placeable.register({ :id            => :COMPOSTER, :usable_locations => [:BASE], :assignable => true, :image => "craftingStations/Composter"}) 
GameData::Placeable.register({ :id            => :GUARDPOST, :usable_locations => [:BASE], :assignable => true, :image => "craftingStations/guard station"}) #Needs a Pokemon to guard base.
GameData::Placeable.register({ :id            => :FEEDER, :usable_locations => [:BASE], :assignable => true, :image => "craftingStations/Feeder"}) #Needs a Pokemon to distribute food.



GameData::Placeable.register({ :id            => :APIARY, :usable_locations => [:BASE_EXTERIOR], :image => "craftingStations/Apiary", :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.bee?
 } })


GameData::Placeable.register({ :id            => :SILKSPINNER, :usable_locations => [:BASE], :image => "craftingStations/Silkspinner", :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.wildHoldItems.include?([:SILK]) && pkmn.hasType?(:BUG)
 } })


   

GameData::Placeable.register({ :id            => :ICEBOX, 
 :assignable => true, :image => "craftingStations/IceBoxClosed", 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ICE)
 } })
GameData::Placeable.register({ :id            => :ELECTRICICEBOX, :needs_power => true, 
 :assignable => true, :image => "craftingStations/EIceBoxClosed", 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ICE)
 } })



GameData::Placeable.register({ :id            => :APRICORNMACHINE, :needs_power => true, :image => "craftingStations/PokeballMachine", :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.species_data.egg_groups.include?(:Humanlike) || pkmn.types.include?(:PSYCHIC)
 } }) #Needs a humanoid Pokemon

GameData::Placeable.register({ :id            => :MILKINGSTATION, :usable_locations => [:BASE], :image => "craftingStations/Feeder", :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.species_data.egg_groups.include?(:Humanlike) || pkmn.types.include?(:PSYCHIC)
 } }) #Needs a humanoid Pokemon
GameData::Placeable.register({ :id            => :POKEGENERATOR, :width => 3, :height => 2, :produces_power => true, :image => "craftingStations/pokegenerator",
 :usable_locations => [:BASE], 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ELECTRIC)
 }})
GameData::Placeable.register({ :id            => :FURNACE, :image => "craftingStations/Furnace", 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:FIRE)
 } 
 })
GameData::Placeable.register({ :id            => :PETBED, :internal_data => [PetBedData], :through => true, :image => "craftingStations/pet bed",
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   localMeter = item.internal_data
   if localMeter.nil? 
     false
   elsif !localMeter.is_a?(PetBedData)
     false
   elsif localMeter.pokemon.nil?
     false
   elsif [:CHANSEY, :BLISSEY, :AUDINO, :SHAYMIN].include?(pkmn.species)
     true
   else 
     localMeter.pokemon.egg?
   end 
 }})
GameData::Placeable.register({ :id            => :PETBEDOUTDOOR, :internal_data => [PetBedData], :through => true, :image => "craftingStations/pet bedo", :usable_locations => [:BASE_EXTERIOR],
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   localMeter = item.internal_data
   if localMeter.nil? 
     false
   elsif !localMeter.is_a?(PetBedData)
     false
   elsif localMeter.pokemon.nil?
     false
   elsif [:CHANSEY, :BLISSEY, :AUDINO, :SHAYMIN].include?(pkmn.species)
     true
   else 
     localMeter.pokemon.egg?
   end 
 }})

