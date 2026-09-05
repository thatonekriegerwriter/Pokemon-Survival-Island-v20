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

    # These three had a get_slot_amount entry (1/2/3 slots respectively)
    # but NO setup_*_ui of their own in the source I was given - they fell
    # through setup_ui's `else` to the generic crafting-bench layout.
    # I've mapped them onto CraftingBench with matching slot counts as the
    # closest faithful guess, but there's no original rendering to check
    # this against - flag if these types are actually used and look wrong
    # in-engine.
    :ELECTRICFURNACE => ->(e, c) { InventoryScene::Stations::Furnace.new(event_data: e, container: c, slots: 1, bg: "ELECTRICFURNACE") },
    :ELECTRICPRESS => ->(e, c) { InventoryScene::Stations::CraftingBench.new(event_data: e, container: c, slots: 2, bg: "ELECTRICPRESS") },
    :SEWINGMACHINE => ->(e, c) { InventoryScene::Stations::CraftingBench.new(event_data: e, container: c, slots: 3, bg: "SEWINGMACHINE") },
  }.freeze

  def self.new(type, event_data, container)
    factory = STATION_FACTORIES[type]
    raise "No station registered for type #{type.inspect} - see STATION_FACTORIES in inv_scene.rb" unless factory

    factory.call(event_data, container)
  end

 

end
