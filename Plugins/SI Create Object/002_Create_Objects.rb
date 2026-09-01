


def getObjectImage(object)
	case object #CAULDRON, CraftingStation, 
	when :CRAFTINGBENCH, :ELECTRICPRESS, :SEWINGMACHINE 
	 image = "craftingStations/CraftingStation"
	when :UPGRADEDCRAFTINGBENCH
	 image = "craftingStations/UCraftingStation"
	when :RESEARCHTABLE
	 image = "craftingStations/ResearchTable"
	when :APRICORNCRAFTING, :APRICORNMACHINE
	 image = "craftingStations/PokeballStationUp"
	when :FURNACE, :ELECTRICFURNACE
	 image = "craftingStations/Furnace"
	when :MACHINEBOX 
	 image = "craftingStations/MachineBox"
	when :GRINDER, :ELECTRICGRINDER
	 image = "craftingStations/Grinder"
	when :TORCH
	 image = "craftingStations/Legends_Torch"
	when :GARBAGEBIN
	 image = "craftingStations/GarbageBin"
	when :WARDINGTOTEM
	 image = "craftingStations/WardingTotem"
	when :BUTCHERTABLE
	 image = "craftingStations/ButcherTable"
	when :CAULDRON
	 image = "craftingStations/Cauldron"
	when :SPRINKLER
	 image = "craftingStations/sprink"
	when :MEDICINEPOT
	 image = "craftingStations/pot"
	when :PETBED
	 image = "craftingStations/pet bed"
	when :PETBEDOUTDOOR
	 image = "craftingStations/pet bedo"
	when :BERRYPOT
	 image = "craftingStations/BerryPot"
	when :COMPOSTER
	 image = "craftingStations/Composter"
	when :SILKSPINNER
	 image = "craftingStations/Silkspinner"
	when :APIARY
	 image = "craftingStations/Apiary"
	when :PORTABLECAMP
	 image = "craftingStations/Tent"
	when :PKMNCRATE
	 image = "craftingStations/cratedown"
	when :ITEMCRATE
	 image = "craftingStations/crateidown"
	when :ICEBOX, :ELECTRICICEBOX
	 image = "craftingStations/IceBoxClosed"
	when :ADVENTUREFLAG
	 image = "craftingStations/AdventureFlag"
	when :COALGENERATOR
	 image = "craftingStations/Furnace"
	when :SOLARGENERATOR
	 image = "craftingStations/Furnace"
	when :WINDGENERATOR
	 image = "craftingStations/Furnace"
	when :HYDROGENERATOR
	 image = "craftingStations/Furnace"
	when :POKEGENERATOR
	 image = "craftingStations/Furnace"
    when :BEDROLL
	 image = "craftingStations/bed"
    when "OvPot"
	 image = "craftingStations/pot"
    when "Egg"
	 image = "craftingStations/egg"
    when "CampsiteDoor"
	 image = nil
	else
	 image = "craftingStations/CraftingStation"
	# puts "002_Create_Objects line 83"
	end

 return image
end





 def get_own_event
	interp = pbMapInterpreter
    this_event = interp.get_self
    return this_event
 end
 def get_own_interp
	interp = pbMapInterpreter
    this_event = interp.get_self
    data = interp.getVariableOther(this_event.id)
    return data
 end
 def get_other_data(id)
	interp = pbMapInterpreter
    data = interp.getVariableOther(id)
    return data
 end
class Game_Event < Game_Character
  attr_accessor :step_anime
  attr_accessor :walk_anime


end 


def deletefromSIData(id,mapid=$game_map.map_id)
  $ExtraEvents.removethisEvent(:OBJECT,id,mapid)
end
def deletefromSISData(id,mapid)
  $ExtraEvents.removethisEvent(:SPECIAL,id,mapid)
end

