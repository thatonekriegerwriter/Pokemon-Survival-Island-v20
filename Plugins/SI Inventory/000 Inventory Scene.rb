def pbCraftingBench(wari,data)
  Inventory.invWindow(wari, data)
end

module Inventory
  def self.invWindow(type="Inventory", event_data = nil ,container = [])
  return if $game_temp.in_inventory==true
  return if $game_temp.assignment_cooldown>0
  $game_temp.in_menu = true
  $game_temp.inv_cooldown = 5
  $OverworldMenu.should_refresh = true 
  craftScene=Inventory_Scene.new(type, event_data, container)
 # craftScene.pbStartScene(type, event_data, container)
  item=craftScene.pbSelectcraft
  $game_temp.in_inventory = false 
  $game_temp.in_menu = false
  if item && item.is_a?(ItemData)
   intret = ItemHandlers.triggerUseFromBag(item)
   itm = GameData::Item.get(item)
    if intret >= 0
      $bag.remove(item) if intret == 1 && itm.consumed_after_use?
	  if $bag.quantity(item)>0
      return item 
	  else 
      return nil 
	  end
    end
   return item
  elsif item.is_a?(TrueClass) || item.is_a?(FalseClass)
    return item 
  end 

  end
end 



class Inventory_Scene
  STATION_FACTORIES = {
    "Inventory" => ->(e, c) { InventoryScene::Stations::Bag.new(event_data: e, container: c) },
    :PETBED => ->(e, c) { InventoryScene::Stations::PetBed.new(event_data: e, container: c) },
    :PETBEDOUTDOOR => ->(e, c) { InventoryScene::Stations::PetBedOutdoor.new(event_data: e, container: c) },
    :FURNACE => ->(e, c) { InventoryScene::Stations::Furnace.new(event_data: e, container: c) },
    :CAULDRON => ->(e, c) { InventoryScene::Stations::Cauldron.new(event_data: e, container: c) },
    :GRINDER => ->(e, c) { InventoryScene::Stations::Grinder.new(event_data: e, container: c) },
    :MEDICINEPOT => ->(e, c) { InventoryScene::Stations::MedicinePot.new(event_data: e, container: c) },
    :CRAFTINGBENCH => ->(e, c) { InventoryScene::Stations::CraftingBench.new(event_data: e, container: c, upgraded: false) },
    :UPGRADEDCRAFTINGBENCH => ->(e, c) { InventoryScene::Stations::CraftingBench.new(event_data: e, container: c, upgraded: true) },
    :APRICORNCRAFTING => ->(e, c) { InventoryScene::Stations::ApricornMachine.new(event_data: e, container: c, machine: false) },
    :APRICORNMACHINE => ->(e, c) { InventoryScene::Stations::ApricornMachine.new(event_data: e, container: c, machine: true) },
    :ITEMCRATE => ->(e, c) { InventoryScene::Stations::ItemCrate.new(event_data: e, container: c) },
    :FEEDER => ->(e, c) { InventoryScene::Stations::ItemCrate.new(event_data: e, container: c) },
    :ICEBOX => ->(e, c) { InventoryScene::Stations::Icebox.new(event_data: e, container: c) },
    :ELECTRICICEBOX => ->(e, c) { InventoryScene::Stations::Icebox.new(event_data: e, container: c) },
    :PKMNCRATE => ->(e, c) { InventoryScene::Stations::PkmnCrate.new(event_data: e, container: c) },
    :RESEARCHTABLE => ->(e, c) { InventoryScene::Stations::ResearchTable.new(event_data: e, container: c) },
    :GARBAGEBIN => ->(e, c) { InventoryScene::Stations::GarbageBin.new(event_data: e, container: c) },
    :COMPOSTER => ->(e, c) { InventoryScene::Stations::Composter.new(event_data: e, container: c) },
    :MACHINEBOX => ->(e, c) { InventoryScene::Stations::MachineBox.new(event_data: e, container: c) },
    :BEDROLL => ->(e, c) { InventoryScene::Stations::Bedroll.new(event_data: e, container: c) },
    :WARDINGTOTEM => ->(e, c) { InventoryScene::Stations::WardingTotem.new(event_data: e, container: c) },
    :BUTCHERTABLE => ->(e, c) { InventoryScene::Stations::ButcherTable.new(event_data: e, container: c) },
    :ADVENTUREFLAG => ->(e, c) { InventoryScene::Stations::AdventureFlag.new(event_data: e, container: c) },
    :APIARY => ->(e, c) { InventoryScene::Stations::BeeHive.new(event_data: e, container: c) },
    :GRAVE => ->(e, c) { InventoryScene::Stations::Grave.new(event_data: e, container: c) },
    :MODIFICATIONTABLE => ->(e, c) { InventoryScene::Stations::ModificationTable.new(event_data: e, container: c) },
    :MOVERELEARNER => ->(e, c) { InventoryScene::Stations::MoveRelearner.new(event_data: e, container: c) },

    :SIFTER => ->(e, c) { InventoryScene::Stations::Sifter.new(event_data: e, container: c, machine: false) },
    :ELECTRICSIFTER => ->(e, c) { InventoryScene::Stations::Sifter.new(event_data: e, container: c, machine: true) },
    :ELECTRICFURNACE => ->(e, c) { InventoryScene::Stations::ElectricFurnace.new(event_data: e, container: c) },
    :COALGENERATOR => ->(e, c) { InventoryScene::Stations::CoalGenerator.new(event_data: e, container: c) },
    :HYDROGENERATOR => ->(e, c) { InventoryScene::Stations::FuellessGenerators.new(event_data: e, container: c) },
    :WINDGENERATOR => ->(e, c) { InventoryScene::Stations::FuellessGenerators.new(event_data: e, container: c) },
    :SOLARGENERATOR => ->(e, c) { InventoryScene::Stations::FuellessGenerators.new(event_data: e, container: c) },
    :POKEGENERATOR => ->(e, c) { InventoryScene::Stations::FuellessGenerators.new(event_data: e, container: c) },
    :ELECTRICQUARRY => ->(e, c) { InventoryScene::Stations::Quarry.new(event_data: e, container: c) },
    :ELECTRICPRESS => ->(e, c) { InventoryScene::Stations::ElectricCraftingBench.new(event_data: e, container: c, slots: 3, bg: "ELECTRICPRESS", power_cost: 60) },
    :SEWINGMACHINE => ->(e, c) { InventoryScene::Stations::ElectricCraftingBench.new(event_data: e, container: c, slots: 3, bg: "SEWINGMACHINE", power_cost: 20) },
    :CUTTER => ->(e, c) { InventoryScene::Stations::ElectricCraftingBench.new(event_data: e, container: c, slots: 1, bg: "CUTTER", power_cost: 60) },
	
    :ELECTRICOREWASHER => ->(e, c) { InventoryScene::Stations::Panner.new(event_data: e, container: c) },
    :TANK => ->(e, c) { InventoryScene::Stations::Tank.new(event_data: e, container: c) },
	
    :ELECTRICPUMP => ->(e, c) { InventoryScene::Stations::WaterMachines.new(event_data: e, container: c) },
    :ELECTRICPURIFIER => ->(e, c) { InventoryScene::Stations::AdvancedWaterMachines.new(event_data: e, container: c) },
    :SPRINKLER => ->(e, c) { InventoryScene::Stations::WaterMachines.new(event_data: e, container: c) },
  }.freeze
#
  def self.new(type, event_data, container)
    factory = STATION_FACTORIES[type]
    raise "No station registered for type #{type.inspect} - see STATION_FACTORIES in inv_scene.rb" unless factory

    factory.call(event_data, container)
  end

 

end
