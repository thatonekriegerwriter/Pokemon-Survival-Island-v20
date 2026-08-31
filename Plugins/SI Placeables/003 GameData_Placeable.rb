module GameData
 class Placeable
    attr_reader :id
    attr_reader :usable_locations
    attr_reader :placement_coordinates
    attr_reader :size
    attr_reader :needs_power
    attr_reader :produces_power

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
	  @produces_power = hash[:produces_power] || false 
    end
    
	
    def name
      return GameData::Item.try_get(@id).name
    end
	
	def assignable?(item, pkmn)
	   @assignable && @assignable_check.call(item, pkmn)
	end 
	
   def self.all
    DATA.values
   end 
   
   def placement_offset(direction)
    @placement_coordinates[direction] || [0, 1]
   end

    def usable_here?(map_id = $game_map.map_id)
	   return true if @usable_locations.include?(:ANY)
       map_metadata = GameData::MapMetadata.try_get(map_id)
	   if map_metadata
	    associated_base = map_metadata.associated_base
	     if associated_base
	      base = GameData::Base.get(associated_base)
		  return true if @usable_locations.include?(:BASE)
		  return true if base.outdoor_maps.include?(map_id) && @usable_locations.include?(:BASE_EXTERIOR)
		  return true if base.indoor_maps.include?(map_id) && @usable_locations.include?(:BASE_INTERIOR)
		  return true if base.can_place_wilds && @usable_locations.include?(:WILDS)
		 else
	      return true if @usable_locations.include?(:WILDS)
		 end
	   else
	     return true if @usable_locations.include?(:WILDS)
	   end 


	   return false 
	end 


 end
end 




GameData::Placeable.register({ :id            => :CRAFTINGBENCH})
GameData::Placeable.register({ :id            => :APRICORNCRAFTING})
GameData::Placeable.register({ :id            => :MEDICINEPOT})
GameData::Placeable.register({ :id            => :BEDROLL, :placement_coordinates =>  { 2 => [0,2], 4 => [-1,0], 6 => [+1,0], 8 => [0,-1]}})
GameData::Placeable.register({ :id            => :CAULDRON})
GameData::Placeable.register({ :id            => :UPGRADEDCRAFTINGBENCH})

GameData::Placeable.register({ :id            => :STATUE})

GameData::Placeable.register({ :id            => :SPRINKLER, :usable_locations => [:BASE]})
GameData::Placeable.register({ :id            => :GARBAGEBIN, :usable_locations => [:BASE]})
GameData::Placeable.register({ :id            => :ITEMCRATE, :usable_locations => [:BASE]})
GameData::Placeable.register({ :id            => :PKMNCRATE, :usable_locations => [:BASE]})

GameData::Placeable.register({ :id            => :TORCH, :usable_locations => [:ANY]})


GameData::Placeable.register({ :id            => :GRAVE, :usable_locations => [:BASE_EXTERIOR]})
GameData::Placeable.register({ :id            => :ADVENTUREFLAG, :usable_locations => [:BASE_EXTERIOR]})
GameData::Placeable.register({ :id            => :WARDINGTOTEM, :usable_locations => [:BASE_EXTERIOR]})

GameData::Placeable.register({ :id            => :MACHINEBOX, :needs_power => true})
GameData::Placeable.register({ :id            => :ELECTRICPRESS, :needs_power => true})
GameData::Placeable.register({ :id            => :ELECTRICFURNACE, :needs_power => true})
GameData::Placeable.register({ :id            => :APRICORNMACHINE, :needs_power => true})
GameData::Placeable.register({ :id            => :SEWINGMACHINE, :needs_power => true})

GameData::Placeable.register({ :id            => :ELECTRICLIGHT, :usable_locations => [:ANY], :needs_power => true})

GameData::Placeable.register({ :id            => :COALGENERATOR, :usable_locations => [:BASE], :produces_power => true })
GameData::Placeable.register({ :id            => :HYDROGENERATOR, :usable_locations => [:BASE_EXTERIOR], :produces_power => true })
GameData::Placeable.register({ :id            => :WINDGENERATOR, :usable_locations => [:BASE_EXTERIOR], :produces_power => true })
GameData::Placeable.register({ :id            => :SOLARGENERATOR, :usable_locations => [:BASE_EXTERIOR], :produces_power => true })

GameData::Placeable.register({ :id            => :PORTABLECAMP, :usable_locations => [:WILDS], :placement_coordinates =>  { 2 => [-1,-1], 4 => [-1,-1], 6 => [-1,-1], 8 => [-1,-1]}})


GameData::Placeable.register({ :id            => :RESEARCHTABLE, :assignable => true})
GameData::Placeable.register({ :id            => :BERRYPOT, :assignable => true}) 
GameData::Placeable.register({ :id            => :BERRYPLANT, :assignable => true}) #If Mushroom, absolutely shoot up mushroom pokemon growth stonks
GameData::Placeable.register({ :id            => :GRINDER, :assignable => true})
GameData::Placeable.register({ :id            => :ELECTRICGRINDER, :assignable => true, :needs_power => true})
GameData::Placeable.register({ :id            => :COMPOSTER, :usable_locations => [:BASE], :assignable => true}) 
GameData::Placeable.register({ :id            => :GUARDPOST, :usable_locations => [:BASE], :assignable => true}) #Needs a Pokemon to guard base.
GameData::Placeable.register({ :id            => :FEEDER, :usable_locations => [:BASE], :assignable => true}) #Needs a Pokemon to distribute food.



GameData::Placeable.register({ :id            => :APIARY, :usable_locations => [:BASE_EXTERIOR], :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   [:COMBEE, :CUTIEFLY, :RIBOMBEE, :VESPIQUEN, :BEEDRILL, :BUTTERFREE, :VOLBEAT, :ILLUMISE].include?(pkmn.species)
 } })


GameData::Placeable.register({ :id            => :SILKSPINNER, :usable_locations => [:BASE], :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   puts pkmn.name 
   puts pkmn.wildHoldItems.inspect 
   puts pkmn.wildHoldItems.include?([:SILK])
   puts pkmn.hasType?(:BUG)
   pkmn.wildHoldItems.include?([:SILK]) && pkmn.hasType?(:BUG)
 } })


   

GameData::Placeable.register({ :id            => :ICEBOX, 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ICE)
 } })
GameData::Placeable.register({ :id            => :ELECTRICICEBOX, :needs_power => true, 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ICE)
 } })

GameData::Placeable.register({ :id            => :MILKINGSTATION, :usable_locations => [:BASE], :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.species_data.egg_groups.include?(:Humanlike)
 } }) #Needs a humanoid Pokemon
GameData::Placeable.register({ :id            => :POKEGENERATOR, :produces_power => true ,
 :usable_locations => [:BASE], 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:ELECTRIC)
 }})
GameData::Placeable.register({ :id            => :FURNACE, 
 :assignable => true, 
 :assignable_check => proc { |item, pkmn|
   pkmn.types.include?(:FIRE)
 } 
 })
GameData::Placeable.register({ :id            => :PETBED,
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
GameData::Placeable.register({ :id            => :PETBEDOUTDOOR, :usable_locations => [:BASE_EXTERIOR],
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

